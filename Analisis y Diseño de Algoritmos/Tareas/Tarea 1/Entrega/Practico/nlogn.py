import math

def nlogn(operations):
    low,hi = 0.0, 10e15
    while True:
        mid = (low+hi)/2
        if low == mid or mid == hi:
            return mid
        if mid*math.log(mid, 10) > operations:
            hi = mid
        else:
            low = mid

print(nlogn(3.6*10e13))