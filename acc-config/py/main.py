#!/usr/bin/env python3

import sys


def input() -> str:
    return sys.stdin.readline().rstrip()


def ints() -> list[int]:
    return list(map(int, input().split()))


def main() -> None:
    pass


if __name__ == "__main__":
    main()
