import xkcd_random


def test_four():
    assert xkcd_random.randint(0, 100) == 4
