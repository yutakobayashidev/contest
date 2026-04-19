#!/usr/bin/env python3

S = input()

y, m, d = S.split("/")

print(f"{y.replace('7', '8')}/{m}/{d}")
