module Purecoin.Utils ( showHexByteStringBE, showHexByteStringLE
                      , integerByteStringBE, integerByteStringLE
                      , integerToNByteStringLE, integerToNByteStringBE
                      ) where

import Data.Word (Word8)
import Data.Bits (Bits, shiftR, shiftL, (.|.), (.&.), bitSize)
import Data.Char (intToDigit)
import qualified Data.ByteString as BS

showHexByteStringBE :: BS.ByteString -> String
showHexByteStringBE = concatMap showOctet . BS.unpack

showHexByteStringLE :: BS.ByteString -> String
showHexByteStringLE = concatMap showOctet . reverse . BS.unpack

showOctet :: Word8 -> String
showOctet w = [wordToDigit (shiftR w 4), wordToDigit (0x0f .&. w)]
 where
   wordToDigit = intToDigit . fromIntegral

integerByteStringLE :: BS.ByteString -> Integer
integerByteStringLE = wordsToIntegerLE . BS.unpack

integerByteStringBE :: BS.ByteString -> Integer
integerByteStringBE = wordsToIntegerLE . reverse . BS.unpack

wordsToIntegerLE :: (Integral a, Bits a) => [a] -> Integer
wordsToIntegerLE = foldr f 0
 where
   f w n =  (toInteger w) .|. shiftL n (bitSize w)

-- produces a ByteString of length n
integerToNByteStringLE :: Int -> Integer -> BS.ByteString
integerToNByteStringLE n = BS.pack . take n . map (fromInteger . (.&. 0xff))
                         . iterate (`shiftR` 8)

integerToNByteStringBE :: Int -> Integer -> BS.ByteString
integerToNByteStringBE n = BS.reverse . integerToNByteStringLE n
