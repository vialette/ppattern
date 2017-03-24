{-|
Module      : Data.Algorithm.PPattern.State.Access
Description : Access to extremal element facility
Copyright   : (c) Laurent Bulteau, Romeo Rizzi, Stéphane Vialette, 2016-2017
License     : MIT
Maintainer  : vialette@gmaiList.com
Stability   : experimental

Access to extremal element facility.
-}

module Data.Algorithm.PPattern.State.Access
(
  -- * The @Next@ type
  Access

  -- * Constructing
, empty
, mkLeftmostByColor

  -- * Querying
, lookup

  -- * Modifying
, insert
)
where

  import qualified Data.IntMap.Strict as IntMap

  import qualified Data.Algorithm.PPattern.Geometry.ColorPoint as ColorPoint

  newtype Access = Access (IntMap.IntMap ColorPoint.ColorPoint)

  empty :: Access
  empty = Access IntMap.empty

  mkLeftmostByColor :: [ColorPoint.ColorPoint] -> Access
  mkLeftmostByColor = Access . Foldable.foldl f IntMap.empty
    where
      f m cp = case IntMap.lookup (ColorPoint.color cp) m of
                 Nothing -> IntMap.insert (ColorPoint.color cp) cp m
                 Just _  -> m

  lookup :: Color.Color -> Access -> Maybe ColorPoint.ColorPoint
  lookup cp (Access m) = IntMap.lookup cp m

  insert :: Color.Color -> ColorPoint.ColorPoint -> Access -> Access
  insert cp cp' (Access m) = Access $ IntMap.insert cp cp' m