#!/usr/bin/env python3

a, n = map(int, input().split())

product = a * n

print("Even" if product * 2 == 0 else "Odd")
