import random
import sys
from functools import cmp_to_key

n = int(sys.argv[1]) if len(sys.argv) > 1 else 100
arr = list(range(n))

arr.sort(key=cmp_to_key(lambda a, b: random.choice([-1, 0, 1])))

print(arr[:100])