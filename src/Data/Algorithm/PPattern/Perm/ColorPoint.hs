{-|
Module      : Data.Algorithm.PPattern.Perm.ColorPoint
Description : Access to extremal element facility
Copyright   : (c) Laurent Bulteau, Romeo Rizzi, Stéphane Vialette, 2016-2017
License     : MIT
Maintainer  : vialette@gmaiList.com
Stability   : experimental

Access to extremal element facility.
-}

module Data.Algorithm.PPattern.Perm.ColorPoint
(
  increasingFactorization
)
where

  import qualified Data.List as List
  import qualified Data.IntMap.Strict as IntMap

  import qualified Data.Algorithm.PPattern.Perm                as Perm
  import qualified Data.Algorithm.PPattern.Geometry.Point      as Point
  import qualified Data.Algorithm.PPattern.Geometry.ColorPoint as CP

  increasingFactorization :: Perm.Perm a -> [CP.ColorPoint]
  increasingFactorization = increasingFactorization' [] IntMap.empty . Perm.points

  increasingFactorization' ::
    [CP.ColorPoint] -> IntMap.IntMap Int -> [Point.Point] -> [CP.ColorPoint]
  increasingFactorization' acc _ []       = List.reverse acc
  increasingFactorization' acc m (p : ps) = increasingFactorization' (cp : acc) m' ps
    where
      y  = Point.yCoord p
      c  = findSmallestColor y m
      m' = case IntMap.lookup c m of
             Nothing -> IntMap.insert c y m
             Just _  -> IntMap.update (\ _ -> Just y) c m
      cp = CP.mk2 p c

  -- Auxialiary function for increasingFactorization'.
  -- Find the smallest color for a new y-coordinate
  findSmallestColor :: Int -> IntMap.IntMap Int -> Int
  findSmallestColor y m = aux 1
    where
      aux c = case IntMap.lookup c m of
                Nothing -> c
                Just y' -> if y' < y then c else aux (c+1)
