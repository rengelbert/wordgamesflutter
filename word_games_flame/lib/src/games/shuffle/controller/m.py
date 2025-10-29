import random

n = [0,1,2,3,4,5,6,7,8,9]
n_ = [2,3,4,5,6,7,8,9]
o = ["+", "-", "*", "/" ]


def get_num(i = 2):
    r = ""
    for _ in range(i):
        r += str(n[random.randint(0, len(n)-1)]) 
        if r == "0": r = ""
    if r == "": r = n_[random.randint(0, len(n_)-1)]
    return r

for _ in range(1000):
    _o = o[random.randint(0, len(o)-1)]
    if _o == "/":
        n1 = get_num(2)
        n2 = get_num(1)
        t = int(n1) * int(n2)
        n1 = str(t) 
    else:    
        n1 = get_num()
        n2 = get_num()
    print(f"{n1} {_o} {n2} = ") 
    