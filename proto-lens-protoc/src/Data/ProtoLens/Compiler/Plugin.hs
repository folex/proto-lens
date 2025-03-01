-- Copyright 2016 Google Inc. All Rights Reserved.
--
-- Use of this source code is governed by a BSD-style
-- license that can be found in the LICENSE file or at
-- https://developers.google.com/open-source/licenses/bsd
--
-- Code for writing protocol compiler plugins.

{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
module Data.ProtoLens.Compiler.Plugin
    ( ProtoFileName
    , ProtoFile(..)
    , analyzeProtoFiles
    , collectEnvFromDeps
    , outputFilePath
    , moduleName
    , moduleNameStr
    ) where

import Data.Char (toUpper)
import Data.List (foldl', intercalate)
import qualified Data.Map.Strict as Map
import Data.Map.Strict (Map, unions, (!))
import Data.Monoid ((<>))
import Data.String (fromString)
import qualified Data.Text as T
import Data.Text (Text)
import Lens.Family2
import Proto.Google.Protobuf.Descriptor (FileDescriptorProto)
import System.FilePath (dropExtension, splitDirectories)

import Data.ProtoLens.Compiler.Definitions

import GHC.SourceGen (ModuleNameStr, OccNameStr, RdrNameStr)

-- | The filename of an input .proto file.
type ProtoFileName = Text

data ProtoFile = ProtoFile
    { descriptor :: FileDescriptorProto
    , haskellModule :: ModuleNameStr
    , definitions :: Env OccNameStr
    , services :: [ServiceInfo]
    , exportedEnv :: Env RdrNameStr
    , publicImports :: [ModuleNameStr]
    }

-- Given a list of FileDescriptorProtos, collect information about each file
-- into a map of 'ProtoFile's keyed by 'ProtoFileName'.
analyzeProtoFiles :: Text -> [FileDescriptorProto] -> Map ProtoFileName ProtoFile
analyzeProtoFiles modulePrefix files =
    Map.fromList [ (f ^. #name, ingestFile f) | f <- files ]
  where
    filesByName = Map.fromList [(f ^. #name, f) | f <- files]
    moduleNames = fmap (moduleName modulePrefix) filesByName
    -- The definitions in each input proto file, indexed by filename.
    definitionsByName = fmap collectDefinitions filesByName
    servicesByName = fmap collectServices filesByName
    exportsByName = transitiveExports files
    exportedEnvs = fmap (foldMap (definitionsByName !)) exportsByName

    ingestFile f = ProtoFile
        { descriptor = f
        , haskellModule = m
        , definitions = definitionsByName ! n
        , services = servicesByName ! n
        , exportedEnv = qualifyEnv m $ exportedEnvs ! n
        , publicImports = [moduleNames ! i | i <- reexported]
        }
      where
        n = f ^. #name
        m = moduleNames ! n
        reexported =
            [ (f ^. #dependency) !! fromIntegral i
            | i <- f ^. #publicDependency
            ]

collectEnvFromDeps :: [ProtoFileName] -> Map ProtoFileName ProtoFile -> Env RdrNameStr
collectEnvFromDeps deps filesByName =
    unions $ fmap (exportedEnv . (filesByName !)) deps

-- | Get the output file path (for CodeGeneratorResponse.File) for a Haskell
-- ModuleName.
outputFilePath :: String -> Text
outputFilePath n = T.replace "." "/" (T.pack n) <> ".hs"

-- | Get the Haskell 'ModuleName' corresponding to a given .proto file.
moduleName :: Text -> FileDescriptorProto -> ModuleNameStr
moduleName modulePrefix fd
      = fromString $ moduleNameStr (T.unpack modulePrefix) (T.unpack $ fd ^. #name)

-- | Get the Haskell module name corresponding to a given .proto file.
moduleNameStr :: String -> FilePath -> String
moduleNameStr prefix path = fixModuleName rawModuleName
  where
    fixModuleName "" = ""
    -- Characters allowed in Bazel filenames but not in module names:
    fixModuleName ('.':c:cs) = '.' : toUpper c : fixModuleName cs
    fixModuleName ('_':c:cs) = toUpper c : fixModuleName cs
    fixModuleName ('-':c:cs) = toUpper c : fixModuleName cs
    fixModuleName (c:cs) = c : fixModuleName cs
    rawModuleName = intercalate "."
                        . (prefix :)
                        . splitDirectories $ dropExtension
                        $ path


-- | Given a list of .proto files (topologically sorted), determine which
-- files' definitions are exported by which files.
--
-- Files only export their own definitions, along with the definitions exported
-- by any "import public" declarations.  (And any definitions that *those* files
-- "import public", etc.)
transitiveExports :: [FileDescriptorProto] -> Map ProtoFileName [ProtoFileName]
-- Accumulate the transitive dependencies by folding over the files in
-- topological order.
transitiveExports = foldl' setExportsFromFile Map.empty
  where
    setExportsFromFile :: Map ProtoFileName [ProtoFileName]
                       -> FileDescriptorProto
                       -> Map ProtoFileName [ProtoFileName]
    setExportsFromFile prevExports fd
        = flip (Map.insert n) prevExports $
            n : concat [ prevExports ! ((fd ^. #dependency) !! fromIntegral i)
                       -- Note that publicDependency is a list of indices into
                       -- the dependency list.
                       | i <- fd ^. #publicDependency
                       ]
      where n = fd ^. #name
