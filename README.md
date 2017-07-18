<!-- python -m readme2tex --usepackage "tikz" --usepackage "xcolor" --output README.md --readme  READOTHER.md --nocdn --pngtrick -->

# PPattern :

## APermutations

### Implementation

```haskell
-- Define in Data.Algorithm.PPattern.Geometry.Point.hs
newtype Point = Point (Int, Int) deriving (Show, Eq, Ord)

-- Define in Data.Algorithm.PPattern.Perm.hs
newtype Perm = Perm { getList :: [Point] } deriving (Eq, Ord)
```

```haskell
mk :: (Foldable t, Ord a) => t a -> APerm a
mk = APerm . fmap (uncurry APerm.T.mk) . reduce . Foldable.toList
```

### Basic manipulation

```haskell
λ: import qualified Data.Algorithm.PPattern.APerm as APerm
λ: let p = APerm.mk "acedb"
λ: p
[1,3,5,4,2]
λ: APerm.annotations p
"acedb"
λ: APerm.toList p
[T (Point (1,1),'a'),T (Point (2,3),'c'),T (Point (3,5),'e'),T (Point (4,4),'d'),T (Point (5,2),'b')]
λ: APerm.toPoints p
[Point (1,1),Point (2,3),Point (3,5),Point (4,4),Point (5,2)]
λ: APerm.xCoords p
[1,2,3,4,5]
λ: APerm.yCoords p
[1,3,5,4,2]
λ:
```

As you might have guessed, `show`reduces to `yCoords`:

```haskell
instance Show (APerm a) where
  show = show . yCoords
```

### Basic properties


### Ties

```haskell
λ: import qualified Data.Algorithm.PPattern.APerm as APerm
λ: let p = APerm.mk "ababc"
λ: p
[1,3,2,4,5]
λ:
```

### Transforming APermutations

The *reverse* of a APermutation <img alt="$\sigma = \sigma_1 \sigma_2 \ldots \sigma_n$" src="svgs/a1cee0d8d3d6654f230ee21d0e3b760f.png?invert_in_darkmode" align=middle width="107.393715pt" height="14.102549999999994pt"/>
is the APermutation <img alt="$r(\sigma) = \sigma_n \sigma_{n-1} \ldots \sigma_1$" src="svgs/df2ffc92edd280590ab07553acd8568f.png?invert_in_darkmode" align=middle width="146.38239pt" height="24.56552999999997pt"/>.
The *complement* <img alt="$c(\sigma)$" src="svgs/d0c33829c8fc0e2f48f678b2b15ebe56.png?invert_in_darkmode" align=middle width="29.772765pt" height="24.56552999999997pt"/> of <img alt="$\sigma$" src="svgs/8cda31ed38c6d59d14ebefa440099572.png?invert_in_darkmode" align=middle width="9.945705000000002pt" height="14.102549999999994pt"/> is the APermutation
<img alt="$\sigma_1' \sigma_2' \ldots \sigma_n'$" src="svgs/0922a5a4b14a88fb2760df363dddf28f.png?invert_in_darkmode" align=middle width="75.57594pt" height="24.668490000000013pt"/> where
<img alt="$\sigma_i' = n+1-\sigma_i$" src="svgs/7092faba1cb42d817c4333a6db603044.png?invert_in_darkmode" align=middle width="108.79769999999999pt" height="24.668490000000013pt"/>.
The *inverse* is the regular group theoretical inverse on APermutations;
that is, the <img alt="$\sigma-i$" src="svgs/b445a63ee573fc22f4bd8ef07545914b.png?invert_in_darkmode" align=middle width="35.6334pt" height="21.602129999999985pt"/>-th position of the inverse <img alt="$\sigma^{-1}$" src="svgs/ec6538b98abdca3ca617fefc81ab0cb8.png?invert_in_darkmode" align=middle width="26.71152pt" height="26.70657pt"/> is occupied by
<img alt="$i$" src="svgs/77a3b857d53fb44e33b53e4c8b68351a.png?invert_in_darkmode" align=middle width="5.642109000000004pt" height="21.602129999999985pt"/>.
Going back to the library,
`reversal`, `complement` and `inverse` yield the reverse, complement and
inverse operations, respectivelly.
`reversalComplement` is the composition of the complement and reverse
(he complement is applied first).

```haskell
λ: import qualified Data.Algorithm.PPattern.APerm as APerm
λ: let p = APerm.mk [3,5,7,1,8,4,2,6]
λ: APerm.reversal p
[6,2,4,8,1,7,5,3]
λ: APerm.complement p
[6,4,2,8,1,5,7,3]
λ: APerm.reversalComplement p
[3,7,5,1,8,2,4,6]
λ: APerm.inverse p
[4,7,1,6,2,8,3,5]
λ:
```

### Composing APermutations

#### Sums

The *skew sum* and *direct sum* of APermutations are two operations
to combine shorter APermutations into longer ones. Given a APermutation <img alt="$\pi$" src="svgs/f30fdded685c83b0e7b446aa9c9aa120.png?invert_in_darkmode" align=middle width="9.922935000000003pt" height="14.102549999999994pt"/>
of length <img alt="$m$" src="svgs/0e51a2dede42189d77627c4d742822c3.png?invert_in_darkmode" align=middle width="14.379255000000002pt" height="14.102549999999994pt"/> and the APermutation <img alt="$\sigma$" src="svgs/8cda31ed38c6d59d14ebefa440099572.png?invert_in_darkmode" align=middle width="9.945705000000002pt" height="14.102549999999994pt"/> of length <img alt="$n$" src="svgs/55a049b8f161ae7cfeb0197d75aff967.png?invert_in_darkmode" align=middle width="9.830040000000002pt" height="14.102549999999994pt"/>,
the skew sum of <img alt="$\pi$" src="svgs/f30fdded685c83b0e7b446aa9c9aa120.png?invert_in_darkmode" align=middle width="9.922935000000003pt" height="14.102549999999994pt"/> and <img alt="$\sigma$" src="svgs/8cda31ed38c6d59d14ebefa440099572.png?invert_in_darkmode" align=middle width="9.945705000000002pt" height="14.102549999999994pt"/> is the APermutation of length <img alt="$m + n$" src="svgs/bfc06c99d626d9ab5e6e152d22661507.png?invert_in_darkmode" align=middle width="44.25267pt" height="19.10667000000001pt"/> defined by
<p align="center"><img alt="$$&#10;(\pi \ominus \sigma )(i)=&#10;\begin{cases}&#10;  \pi (i)+n    &amp; \text{for } 1\leq i\leq m,\\&#10;  \sigma (i-m) &amp; \text{for } m+1\leq i\leq m+n,&#10;\end{cases}&#10;$$" src="svgs/3aae7275be8202e4597f9f6d34103e3d.png?invert_in_darkmode" align=middle width="351.49454999999995pt" height="49.131389999999996pt"/></p>

and the direct sum of <img alt="$\pi$" src="svgs/f30fdded685c83b0e7b446aa9c9aa120.png?invert_in_darkmode" align=middle width="9.922935000000003pt" height="14.102549999999994pt"/> and <img alt="$\sigma$" src="svgs/8cda31ed38c6d59d14ebefa440099572.png?invert_in_darkmode" align=middle width="9.945705000000002pt" height="14.102549999999994pt"/> is the APermutation of length <img alt="$m + n$" src="svgs/bfc06c99d626d9ab5e6e152d22661507.png?invert_in_darkmode" align=middle width="44.25267pt" height="19.10667000000001pt"/> defined by
<p align="center"><img alt="$$&#10;(\pi \oplus \sigma )(i)=&#10;\begin{cases}&#10;  \pi (i)          &amp; \text{for } 1\leq i\leq m,\\&#10;  \sigma (i-m) + m &amp; \text{for } m+1\leq i\leq m+n.&#10;\end{cases}&#10;$$" src="svgs/e932e8bc54791046d9f921e31d159298.png?invert_in_darkmode" align=middle width="386.01914999999997pt" height="49.131389999999996pt"/></p>

```haskell
λ: import qualified Data.Algorithm.PPattern.APerm as APerm
λ: import qualified Data.Algorithm.PPattern.APerm.Sum as APerm.Sum
λ: let p = APerm.mk [2,4,1,3]
λ: let q = APerm.mk [3,5,1,4,2]
λ: APerm.Sum.skewSum p q
[7,9,6,8,3,5,1,4,2]
λ: APerm.Sum.directSum p q
[2,4,1,3,7,9,5,8,6]
λ:
```

### Basic statistics

```haskell
λ: import qualified Data.Algorithm.PPattern.APerm as APerm
λ: import qualified Data.Algorithm.PPattern.APerm.Statistics as APerm.Statistics
λ: let p = APerm.mk [7,5,3,8,2,1,4,9,6]
λ: APerm.Statistics.leftToRightMinima p
[7,5,3,2,1]
λ: APerm.Statistics.leftToRightMaxima p
[7,8,9]
λ: APerm.Statistics.rightToLeftMinima p
[1,4,6]
λ: APerm.Statistics.rightToLeftMaxima p
[9,6]
λ: APerm.Statistics.ascents p
[3,1,4]
λ: APerm.Statistics.doubleAscents p
[1]
λ: APerm.Statistics.descents p
[7,5,8,2,9]
λ: APerm.Statistics.doubleDescents p
[7,8]
λ: APerm.Statistics.peaks p
[8,9]
λ: APerm.Statistics.valleys p
[3,1]
λ:
```

### APermutation graphs

## Pattern matching

### Generic pattern matching

### Monotone patterns

### Separable patterns

### Size-3 patterns

### Size-4 patterns

## APermutation classes

### Separable APermutations

A separable APermutation is a APermutation that can be obtained from the trivial
APermutation 1 by direct sums and skew sums;
separable APermutations may be characterized by the forbidden APermutation patterns
2413 and 3142
(see <https://en.wikipedia.org/wiki/Separable_APermutation>).

```haskell
λ: import qualified Data.Algorithm.PPattern.APerm as APerm
λ: import qualified Data.Algorithm.PPattern.SeparatingTree as SeparatingTree
λ: let p = APerm.mk [3,1,4,2,6,5,7]
λ: -- p does not avoid 2413 and 3142, and hence is not separable
λ: APerm.isSeparable p                  
False
λ: -- so that no separating tree of p can be obtained
λ: SeparatingTree.mk <img alt="<img alt="$ APerm.toPoints p&amp;#10;Nothing&amp;#10;λ: let q = APerm.mk [3,1,2,4,6,5,7]&amp;#10;λ: APerm.isSeparable q                             -- q does avoid 2413 and 3142, and hence is separable&amp;#10;True&amp;#10;λ: import Data.Maybe&amp;#10;λ: fromJust . SeparatingTree.mk $" src="svgs/6cf3447b0450166911e817c41625f463.png?invert_in_darkmode" align=middle width="841.26405pt" height="45.82083000000002pt"/>" src="https://rawgit.com/in	git@github.com:vialette/ppattern/None/svgs/c7be5bdfada4253d65cf69b07d4cdacb.svg?invert_in_darkmode" align=middle width="1011.5407499999999pt" height="45.82083000000002pt"/> APerm.toPoints q -- so that a separating tree of q can be obtained
+ Interval (1,7)
.+ Interval (1,6)
..+ Interval (1,4)
...- Interval (1,3)
....Point (1,3)
....+ Interval (1,2)
.....Point (2,1)
.....Point (3,2)
...Point (4,4)
..- Interval (5,6)
...Point (5,6)
...Point (6,5)
.Point (7,7)

λ:
```

### (213,231)-avoiding patterns

## Computing a base
