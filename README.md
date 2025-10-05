# xkcd-random

Drop in replacement for random module that forces the core random number function to return 0.4.

Uses the [xkcd-221 algorithm](https://xkcd.com/221/).

![Function Returns 4](https://imgs.xkcd.com/comics/random_number.png
"XKCD Random Number Generator")

## Installation

`pip install xkcd-random`

## Usage

```python
import xkcd_random as random

print(random.randint(0, 10))
```

## Caveats

Some functions return something other than 4/6 or 4 because the random.random() function's results are manipulated
before being returned to the user.

APIs might return 4 or 4/6, I don't know I haven't really tested it that well. You guys sure are picky about what random
numbers you want. You know, here use this

```python
import random

random.randint = lambda x: int(input("role a die"))
```

## Implementation

`SimpleOverrideXKCDRandom` overrides 4 methods of Random() like the docstring suggests.

```python
from random import Random


class SimpleOverrideXKCDRandom(Random):
    def random(self) -> float: return float(4 / 6)

    def getrandbits(self, k: int) -> int: return 4

    def seed(self, *_): ...

    def setstate(self, _): return ()

    def getstate(self): ...
```

`xkcd_random` is a fork of python 3.13. You can actually use this sensibly, with "system" (real randomness) or
"xkcd" (it is 4.)

```python
import xkcd_random

random = xkcd_random.Random(core=xkcd_random.SystemCore())
```

or

```python
import os

os.environ["RANDOM_BACKEND"] = "system"
import xkcd_random as random
```

## License

This code is copied directly from the python 3.11 so
the [license is the same as CPython's](https://github.com/python/cpython/blob/3.13/LICENSE). Anything not covered
by the cpython license is covered by MIT.

## Prior Art and Similar Libraries

This list has an emphasis on "drop in replacements"

- [RandomSources](https://pypi.org/project/RandomSources/)
- [nonpseudorandom](https://pypi.org/project/nonpseudorandom/)
- [Pyewacket](https://pypi.org/project/Pyewacket/)
- [quantum-random](https://pypi.org/project/quantum-random/)
- [pycrypto](https://pypi.org/project/pycrypto/)