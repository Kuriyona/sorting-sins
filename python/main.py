import random

arr = list(range(100))

arr.sort(key=lambda x: random.random())

print(arr)