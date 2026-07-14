import random
from functools import cmp_to_key

arr = list(range(100))

arr.sort(key=cmp_to_key(lambda a, b: random.choice([-1, 0, 1])))

print(arr)