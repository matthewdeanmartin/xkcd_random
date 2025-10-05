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

Some functions return something other than 0.4 or 4 because the random.random() function's results are manipulated
before being returned to the user.

## License

This code is copied directly from the python 3.11 so
the [license is the same as CPython's](https://github.com/python/cpython/blob/3.13/LICENSE). Anything not covered
by the cpython license is covered by MIT.

