import math

#Sigmoid function
func sigmoid*(x:float,gain:float = 1.0):float = 
  1.0 / (1.0 + pow(E,-gain * x))

#Curried sigmoid function
func sigmoidCurried*(gain:float):proc (n:float):float =
  result = proc (x:float):float =
    sigmoid(x,gain)

#Linear function
func linear*(x:float):float = x

#Step function
func step*(x:float,thre=0.5):float = 
  if x < thre:
    0.0
  else:
    1.0

#Curried Step function
func stepCurried*(thre = 0.5):proc (n:float):float =
  result = proc (x:float):float =
    step(x,thre)

