{- This file was auto-generated from google/protobuf/compiler/plugin.proto by the proto-lens-protoc program. -}
{-# LANGUAGE ScopedTypeVariables, DataKinds, TypeFamilies, UndecidableInstances, GeneralizedNewtypeDeriving, MultiParamTypeClasses, FlexibleContexts, FlexibleInstances, PatternSynonyms, MagicHash, NoImplicitPrelude, DataKinds, BangPatterns, TypeApplications#-}
{-# OPTIONS_GHC -Wno-unused-imports#-}
{-# OPTIONS_GHC -Wno-duplicate-exports#-}
{-# OPTIONS_GHC -Wno-dodgy-exports#-}
module Proto.Google.Protobuf.Compiler.Plugin_Fields where
import qualified Prelude
import qualified Data.Int
import qualified Data.Monoid
import qualified Data.Word
import qualified Data.ProtoLens
import qualified Data.ProtoLens.Encoding.Bytes
import qualified Data.ProtoLens.Encoding.Growing
import qualified Data.ProtoLens.Encoding.Parser.Unsafe
import qualified Data.ProtoLens.Encoding.Wire
import qualified Data.ProtoLens.Field
import qualified Data.ProtoLens.Message.Enum
import qualified Data.ProtoLens.Service.Types
import qualified Lens.Family2
import qualified Lens.Family2.Unchecked
import qualified Data.Text
import qualified Data.Map
import qualified Data.ByteString
import qualified Data.ByteString.Char8
import qualified Data.Text.Encoding
import qualified Data.Vector
import qualified Data.Vector.Generic
import qualified Data.Vector.Unboxed
import qualified Text.Read
import qualified Proto.Google.Protobuf.Descriptor
compilerVersion ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "compilerVersion" a) =>
  Lens.Family2.LensLike' f s a
compilerVersion = Data.ProtoLens.Field.field @"compilerVersion"
content ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "content" a) =>
  Lens.Family2.LensLike' f s a
content = Data.ProtoLens.Field.field @"content"
error ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "error" a) =>
  Lens.Family2.LensLike' f s a
error = Data.ProtoLens.Field.field @"error"
file ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "file" a) =>
  Lens.Family2.LensLike' f s a
file = Data.ProtoLens.Field.field @"file"
fileToGenerate ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "fileToGenerate" a) =>
  Lens.Family2.LensLike' f s a
fileToGenerate = Data.ProtoLens.Field.field @"fileToGenerate"
insertionPoint ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "insertionPoint" a) =>
  Lens.Family2.LensLike' f s a
insertionPoint = Data.ProtoLens.Field.field @"insertionPoint"
major ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "major" a) =>
  Lens.Family2.LensLike' f s a
major = Data.ProtoLens.Field.field @"major"
maybe'compilerVersion ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'compilerVersion" a) =>
  Lens.Family2.LensLike' f s a
maybe'compilerVersion
  = Data.ProtoLens.Field.field @"maybe'compilerVersion"
maybe'content ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'content" a) =>
  Lens.Family2.LensLike' f s a
maybe'content = Data.ProtoLens.Field.field @"maybe'content"
maybe'error ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'error" a) =>
  Lens.Family2.LensLike' f s a
maybe'error = Data.ProtoLens.Field.field @"maybe'error"
maybe'insertionPoint ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'insertionPoint" a) =>
  Lens.Family2.LensLike' f s a
maybe'insertionPoint
  = Data.ProtoLens.Field.field @"maybe'insertionPoint"
maybe'major ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'major" a) =>
  Lens.Family2.LensLike' f s a
maybe'major = Data.ProtoLens.Field.field @"maybe'major"
maybe'minor ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'minor" a) =>
  Lens.Family2.LensLike' f s a
maybe'minor = Data.ProtoLens.Field.field @"maybe'minor"
maybe'name ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'name" a) =>
  Lens.Family2.LensLike' f s a
maybe'name = Data.ProtoLens.Field.field @"maybe'name"
maybe'parameter ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'parameter" a) =>
  Lens.Family2.LensLike' f s a
maybe'parameter = Data.ProtoLens.Field.field @"maybe'parameter"
maybe'patch ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'patch" a) =>
  Lens.Family2.LensLike' f s a
maybe'patch = Data.ProtoLens.Field.field @"maybe'patch"
maybe'suffix ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "maybe'suffix" a) =>
  Lens.Family2.LensLike' f s a
maybe'suffix = Data.ProtoLens.Field.field @"maybe'suffix"
minor ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "minor" a) =>
  Lens.Family2.LensLike' f s a
minor = Data.ProtoLens.Field.field @"minor"
name ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "name" a) =>
  Lens.Family2.LensLike' f s a
name = Data.ProtoLens.Field.field @"name"
parameter ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "parameter" a) =>
  Lens.Family2.LensLike' f s a
parameter = Data.ProtoLens.Field.field @"parameter"
patch ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "patch" a) =>
  Lens.Family2.LensLike' f s a
patch = Data.ProtoLens.Field.field @"patch"
protoFile ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "protoFile" a) =>
  Lens.Family2.LensLike' f s a
protoFile = Data.ProtoLens.Field.field @"protoFile"
suffix ::
  forall f s a.
  (Prelude.Functor f, Data.ProtoLens.Field.HasField s "suffix" a) =>
  Lens.Family2.LensLike' f s a
suffix = Data.ProtoLens.Field.field @"suffix"
vec'file ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "vec'file" a) =>
  Lens.Family2.LensLike' f s a
vec'file = Data.ProtoLens.Field.field @"vec'file"
vec'fileToGenerate ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "vec'fileToGenerate" a) =>
  Lens.Family2.LensLike' f s a
vec'fileToGenerate
  = Data.ProtoLens.Field.field @"vec'fileToGenerate"
vec'protoFile ::
  forall f s a.
  (Prelude.Functor f,
   Data.ProtoLens.Field.HasField s "vec'protoFile" a) =>
  Lens.Family2.LensLike' f s a
vec'protoFile = Data.ProtoLens.Field.field @"vec'protoFile"