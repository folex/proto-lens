-- Copyright 2016 Google Inc. All Rights Reserved.
--
-- Use of this source code is governed by a BSD-style
-- license that can be found in the LICENSE file or at
-- https://developers.google.com/open-source/licenses/bsd

{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.ProtoLens
import Lens.Family2 ((&), (.~), (^.))
import qualified Data.ByteString.Builder as Builder
import Data.Monoid ((<>))
import Proto.Proto3
    ( Foo
    , Foo'FooEnum(..)
    , Foo'Sub
    , Strings
    )
import Proto.Proto3_Fields
    ( a
    , b
    , c
    , d
    , e
    , f
    , s
    , sub
    , maybe'c
    , maybe'sub
    , maybe's
    , enum
    , bytes
    , string
    )
import Test.Tasty (testGroup)
import Test.Tasty.HUnit (testCase)
import Test.HUnit ((@=?), assertBool)

import Data.ProtoLens.TestUtil

main :: IO ()
main = testMain
  [ testGroup "Foo"
    [ serializeTo "int32"
        (defMessage & a .~ 150 :: Foo)
        "a: 150"
        $ tagged 1 $ VarInt 150
    , serializeTo "repeated-string"
        (defMessage & b .~ ["one", "two"] :: Foo)
        (vcat $ map (keyedStr "b") ["one", "two"])
        $ mconcat (map (tagged 2 . Lengthy) ["one", "two"])
    , testGroup "oneof"
        [ serializeTo "float"
            -- Use denominators that aren't divisible by 2, to fill out the bits.
            (defMessage & c .~ (20 / 3) :: Foo)
            "c: 6.6666665"
            $ tagged 3 $ Fixed32 0x40d55555
        , serializeTo "bytes"
            (defMessage & d .~ "a\0b" :: Foo)
            "d: \"a\\000b\""
            $ tagged 4 $ Lengthy "a\0b"
        , serializeTo "overridden value"
            (defMessage & d .~ "a\0b" & c .~ (20 / 3) :: Foo)
            "c: 6.6666665"
            $ tagged 3 $ Fixed32 0x40d55555
        -- Scalar "oneof" fields should have a "maybe" selector.
        , testCase "maybe" $ do
            Nothing @=? (defMessage :: Foo) ^. maybe'c
            Just 42 @=? ((defMessage :: Foo) & c .~ 42) ^. maybe'c
            Nothing @=? (defMessage :: Foo) ^. maybe's
        , testCase "message" $ do
            Just 42 @=? ((defMessage :: Foo) & s .~ (defMessage :: Foo'Sub) & c .~ 42) ^. maybe'c
            Nothing @=? ((defMessage :: Foo) & s .~ (defMessage :: Foo'Sub) & c .~ 42) ^. maybe's
            17 @=? ((defMessage :: Foo) & s . e .~ 17) ^. s . e
            let val = (defMessage :: Foo'Sub) & e .~ 17
            Just val @=? ((defMessage :: Foo) & s .~ val) ^. maybe's
        ]
    -- Repeated scalar fields in proto3 should serialize as "packed" by default.
    , serializeTo "packed-by-default"
        (defMessage & f .~ [1,2,3] :: Foo)
        (vcat [keyedInt "f" x | x <- [1..3]])
        $ tagged 7 $ Lengthy $ mconcat [varInt x | x <- [1..3]]
    , runTypedTest (roundTripTest "foo" :: TypedTest Foo)
    ]
  , testGroup "Strings"
    [ deserializeFrom "bytes"
        (Just $ defMessage & bytes .~ toStrictByteString invalidUtf8 :: Maybe Strings)
        $ tagged 1 $ Lengthy invalidUtf8
    , deserializeFrom "string"
        (Nothing :: Maybe Strings)
        $ tagged 2 $ Lengthy invalidUtf8
    ]
  -- Scalar field defaults are indistinguishable from unset fields.
  , testGroup "defaulting"
      [ testCase "int" $ (defMessage :: Foo) @=? (defMessage & a .~ 0)
      , testCase "bytes" $ (defMessage :: Strings) @=? (defMessage & bytes .~ "")
      , testCase "string" $ (defMessage :: Strings) @=? (defMessage & string .~ "")
      , testCase "enum" $ (defMessage :: Foo) @=? (defMessage & enum .~ Foo'Enum1)
      ]
  -- Enums are sum types, except for aliases
  , testGroup "enum"
      [ testCase "aliases are exported" $ Foo'Enum2 @=? Foo'Enum2a
      , serializeTo "serializeTo enum"
          (defMessage & enum .~ Foo'Enum2 :: Foo)
          "enum: Enum2"
          $ tagged 6 $ VarInt 3
      , serializeTo "serializeTo unrecognized"
          (defMessage & enum .~ toEnum 9 :: Foo)
          "enum: 9"
          $ tagged 6 $ VarInt 9
      , testCase "enum values" $ do
          map toEnum [0, 3, 3] @=? [Foo'Enum1, Foo'Enum2, Foo'Enum2a]
          fromEnum <$> (maybeToEnum 4 :: Maybe Foo'FooEnum) @=? Just 4
          ["Foo'Enum1", "Foo'Enum2", "Foo'Enum2", "Foo'FooEnum'Unrecognized (Foo'FooEnum'UnrecognizedValue 5)"]
              @=? map show [Foo'Enum1, Foo'Enum2, Foo'Enum2a, toEnum 5]
          ["Enum1", "Enum2", "Enum2", "6"]
              @=? map showEnum [Foo'Enum1, Foo'Enum2, Foo'Enum2a, toEnum 6]
          [Just Foo'Enum1, Just Foo'Enum2, Just Foo'Enum2, maybeToEnum 4, maybeToEnum 5]
              @=? map readEnum ["Enum1", "Enum2", "Enum2a", "4", "5"]
      , testCase "enum patterns" $ do
          assertBool "enum value" $ case toEnum 3 of
                                      Foo'Enum2 -> True
                                      _ -> False
          assertBool "enum alias" $ case toEnum 3 of
                                      Foo'Enum2a -> True
                                      _ -> False

      ]
  -- Unset proto3 messages are different than the default value.
  , testGroup "submessage"
      [ testCase "Nothing" $ Nothing @=? ((defMessage :: Foo) ^. maybe'sub)
      , testCase "Just" $ do
          let val = (defMessage :: Foo'Sub) & e .~ 3
          Just val @=? ((defMessage :: Foo) & sub .~ val) ^. maybe'sub
      ]
  ]


invalidUtf8 :: Builder.Builder
invalidUtf8 = Builder.word8 0xc3 <> Builder.word8 0x28
