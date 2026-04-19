#!/usr/bin/env python3

N = int(input())

arry = []

for i in range(N):
    item = input()
    arry.append(item)

print(len(set(arry)))
