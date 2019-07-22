{.experimental.}
import math
import strformat
import random

type
  Vector* = ref seq[float]

#Create a new Vector
proc newVector*(size:int):Vector = 
  result = new seq[float]
  result[] = newSeq[float](size)

#Create a new random Vector
proc randomVector*(size:int):Vector = 
  result = newVector(size)
  for idx,v in result:
    result[idx] = rand(1.0)

#Vector map by function of `f`
func map*(v:Vector,f:proc (x:float):float):Vector =
  result = newVector(v.len)
  for idx,value in v:
    result[idx] = f(value)


# Average
func average*(v:Vector):float = v.sum / float(v.len)

# Variance
func variance*(v:Vector):float =
  let ave = v.average
  v.map(proc (x:float):float = pow(x - ave,2)).sum / float(v.len)

# Standard
func standard*(v:Vector):float = sqrt(v.variance)


proc describe*(v:Vector)=
  echo fmt"length:{v.len}"
  echo fmt"summary:{v.sum}"
  echo fmt"average:{v.average}"
  echo fmt"variance:{v.variance}"
  echo fmt"standard:{v.standard}"

func minmaxNormalize*(v:Vector):Vector = 
  let min_v = v.min
  let max_v = v.max
  v.map(proc (x:float):float =
    (x-min_v) / (max_v - min_v)
  )

func standardize*(v:Vector):Vector=
  let std = v.standard
  let ave = v.average
  v.map(proc (x:float):float = (x - ave) / std)

func `*`*(self:Vector,right:Vector):Vector =
  result = newVector(self.len)
  for idx,value in self:
    result[idx] = value * right[idx]

func `*`*(self:Vector,right:float):Vector = 
  self.map(proc(x:float):float = x * right)

func `*`*(self:float,right:Vector):Vector = right * self

func `/`*(self:Vector,right:Vector):Vector =
  result = newVector(self.len)
  for idx,value in self:
    result[idx] = value / right[idx]

func `/`*(self:Vector,right:float):Vector=
  self.map(proc(x:float):float = x / right)

func `+`*(self:Vector,right:Vector):Vector =
  result = newVector(self.len)
  for idx,value in self:
    result[idx] = value + right[idx]

func `+`*(self:Vector,right:float):Vector=
  self.map(proc(x:float):float = x + right)

func `+`*(self:float,right:Vector):Vector = right + self

func `-`*(self:Vector,right:Vector):Vector = 
  result = newVector(self.len)
  for idx,value in self:
    result[idx] = value - right[idx]

func `-`*(self:Vector,right:float):Vector =
  self.map(proc(x:float):float = x - right)
