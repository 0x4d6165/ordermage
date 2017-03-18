module Utils where

import Data.ByteString.Internal (unpackBytes)
import Data.UUID
import Data.ByteString.Char8 (pack)
import Data.UUID.V4
import Data.UUID.V5
import System.IO.Unsafe (unsafePerformIO)
import GHC.Word

strToWord8s :: String -> [Word8]
strToWord8s = unpackBytes . pack

genV5UUID :: String -> UUID
genV5UUID object = generateNamed (unsafePerformIO nextRandom) (strToWord8s object)
