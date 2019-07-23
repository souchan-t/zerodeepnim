{.experimental.}
import math
import strformat
import random

type
  Vector* = ref seq[float]
  Matrix* = ref seq[Vector]

  FtoFFunction = proc(x:float):float
  VtoVFunction = proc(v:Vector):Vector

#Create a new Vector
func newVector*(size:int):Vector = 
  result = new seq[float]
  result[] = newSeq[float](size)

func newVector*(arr:seq[float]):Vector=
  result = new seq[float]
  result[] = arr

#Create a new random Vector
proc randomVector*(size:int,max:float=1.0,seed:int=1):Vector = 
  result = newVector(size)
  randomize(seed)
  for idx,v in result:
    result[idx] = rand(max)

#Vector map by function of `f`
func map*[R](v:Vector,f:proc(x:float):R):Vector =
  result = newVector(v.len)
  for idx,value in v:
    result[idx] = f(value)

func foreach*(v:Vector,f:proc (index:int,x:float))=
  for idx,value in v:
    f(idx,value)

# Average
func average*(v:Vector):float= v.sum / float(v.len)

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

# scalar積
func dot*(self:Vector,right:Vector):float= (self * right).sum
func `@`*(self:Vector,right:Vector):float= self.dot(right)

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


proc newMatrix*(widht:int,height:int):Matrix=
  result = new seq[Vector]
  result[] = newSeq[Vector](height)
  for idx,value in result:
    result[idx] = newVector(widht)

proc newMatrix*(height:int):Matrix=
  result = new seq[Vector]
  result[] = newSeq[Vector](height)

proc newMatrix*(matrix:seq[seq[float]]):Matrix =
  let h = matrix.len
  result = newMatrix(h)
  for idx,v in result:
    result[idx] = newVector(matrix[idx])

func `$`*(mat:Matrix):string=
  result = ""
  for i,v in mat:
    result.add $v
    result.add "\n"

func shape*(mat:Matrix):array[2,int] =
  let w = if mat[0] == nil:
    0
  else:
    mat[0].len
  let h = mat.len
  result = [w,h]

func map*(mat:Matrix,f:VtoVFunction):Matrix =
  let shape = mat.shape
  result = newMatrix(shape[0],shape[1])
  for idx,v in mat:
    result[idx] = f(v)

func transpose*(mat:Matrix):Matrix = 
  let shape = mat.shape
  result = newMatrix(shape[1],shape[0])
  for i,v in mat:
    for j,c in v:
      result[j][i] = c

func dot*(mat1:Matrix,mat2:Matrix):Matrix=
  let t_mat2 = mat2.transpose
  result = newMatrix(mat1.shape()[1],mat2.shape()[0])
  for i,v1 in mat1:
    for j,v2 in t_mat2:
      result[i][j] = v1 @ v2

func `@`*(mat1:Matrix,mat2:Matrix):Matrix = mat1.dot(mat2)

let m1 = newMatrix(@[@[1.0,2.0,3.0,4.0],@[4.0,5.0,6.0,7.0]])
let m2 = newMatrix(@[@[1.0,2.0],@[3.0,4.0],@[4.0,5.0],@[6.0,7.0]])

echo m1 @ m2
