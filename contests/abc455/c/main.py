from collections import Counter

N, K = map(int, input().split())
A = list(map(int, input().split()))

cnt = Counter(A)

scores = []
for x, c in cnt.items():
    scores.append(x * c)

scores.sort(reverse=True)

print(sum(scores[K:]))
