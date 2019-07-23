{.experimental.}
import math
import strformat
import random

type
  Vector*[T] = ref seq[T]
  Matrix*[T] = ref seq[Vector[T]]
  
  FloatVector* = Vector[float]
  FloatMatrix* = Matrix[float]

#--------------------------------------------
# Vector proc
#--------------------------------------------
#Create a new Vector
func newVector*[T](size:int):Vector[T] = 
  result = new seq[T]
  result[] = newSeq[T](size)

func newVector*[T](arr:seq[T]):Vector[T]=
  result = new seq[T]
  result[] = arr

func newVector*[IDX,T](arr:array[IDX,T]):Vector[T]=
  result = new seq[T]
  result[] = @arr

#Create a new random Vector
proc randomVector*[T](size:int,max:T,seed:int=1):Vector[T] = 
  result = newVector(size)
  randomize(seed)
  for idx,v in result:
    result[idx] = rand(max)

#Vector map by function of `f`
func map*[T,R](v:Vector[T],f:proc(x:T):R):Vector[R] =
  result = newVector[R](v.len)
  for idx,value in v:
    result[idx] = f(value)

proc apply*[T](v:Vector[T],f:proc(x:T):T)=
  for idx,value in v:
    v[idx] = f(value)

func fillter*[T](v:Vector[T],cond:proc(x:T):bool):Vector[T]=
  result = newVector[T](0)
  for idx,value in v:
    if cond(value):
      result.add(value)


  
func foreach*[T](v:Vector[T],f:proc (index:int,x:T))=
  for idx,value in v:
    f(idx,value)

# Average
func average*[T](v:Vector[T]):T= T(v.sum / T(v.len))


# Variance
func variance*[T](v:Vector[T]):T=
  let ave = v.average
  T(v.map(proc (x:T):T= T(pow(float(x) - float(ave),2))).sum / T(v.len))

# Standard
func standard*[T](v:Vector[T]):T= T(sqrt(float(v.variance)))


proc describe*[T](v:Vector[T])=
  echo fmt"length:{v.len}"
  echo fmt"summary:{v.sum}"
  echo fmt"average:{v.average}"
  echo fmt"variance:{v.variance}"
  echo fmt"standard:{v.standard}"

func minmaxNormalize*[T](v:Vector[T]):Vector[T] = 
  let min_v = v.min
  let max_v = v.max
  v.map(proc (x:T):T =
    (x-min_v) / (max_v - min_v)
  )

func standardize*[T](v:Vector):Vector[T]=
  let std = v.standard
  let ave = v.average
  v.map(proc (x:T):T = (x - ave) / std)


func `&`*[T](self:Vector[T],right:Vector[T]):Vector[T] = 
  result = newVector[T](self.len + right.len)
  for idx,v in self:
    result[idx] = v
  for idx,v in right:
    result[self.len + idx] = v

func `*`*[T](self:Vector[T],right:Vector[T]):Vector[T] =
  result = newVector[T](self.len)
  for idx,value in self:
    result[idx] = value * right[idx]

func `*`*[T](self:Vector[T],right:T):Vector[T] = 
  self.map(proc(x:T):T = x * right)

# scalar積
func dot*[T](self:Vector[T],right:Vector[T]):T= (self * right).sum
func `@`*[T](self:Vector[T],right:Vector[T]):T= self.dot(right)

func `*`*[T](self:T,right:Vector[T]):Vector[T] = right * self

func `/`*[T](self:Vector[T],right:Vector[T]):Vector[T] =
  result = newVector[T](self.len)
  for idx,value in self:
    result[idx] = value / right[idx]

func `/`*[T](self:Vector[T],right:T):Vector[T]=
  self.map(proc(x:T):T = x / right)

func `+`*[T](self:Vector[T],right:Vector[T]):Vector[T] =
  result = newVector[T](self.len)
  for idx,value in self:
    result[idx] = value + right[idx]

func `+`*[T](self:Vector[T],right:T):Vector[T]=
  self.map(proc(x:T):T = x + right)

func `+`*[T](self:T,right:Vector[T]):Vector[T] = right + self

func `-`*[T](self:Vector[T],right:Vector[T]):Vector[T] = 
  result = newVector[T](self.len)
  for idx,value in self:
    result[idx] = value - right[idx]

func `-`*[T](self:Vector[T],right:T):Vector[T] =
  self.map(proc(x:T):T= x - right)

# -------------------------------------------
# Matrix proc
# -------------------------------------------

proc newMatrix*[T](widht:int,height:int):Matrix[T]=
  result = new seq[Vector[T]]
  result[] = newSeq[Vector[T]](height)
  for idx,value in result:
    result[idx] = newVector[T](widht)

proc newMatrix*[T](height:int):Matrix[T]=
  result = new seq[Vector[T]]
  result[] = newSeq[Vector[T]](height)

proc newMatrix*[T](matrix:seq[seq[T]]):Matrix[T] =
  let h = matrix.len
  result = newMatrix[T](h)
  for idx,v in result:
    result[idx] = newVector(matrix[idx])

proc newMatrix*[T](vec:Vector[T]):Matrix[T]=
  result = newMatrix[T](1)
  for idx,v in result[0]:
    result[0][idx] = vec[idx]

func `$`*[T](mat:Matrix[T]):string=
  result = ""
  for i,v in mat:
    result.add $v
    result.add "\n"

func shape*[T](mat:Matrix[T]):array[2,int] =
  let w = if mat[0] == nil:
    0
  else:
    mat[0].len
  let h = mat.len
  result = [w,h]

func map*[T,R](mat:Matrix[T],f:proc(x:Vector[T]):R):Matrix[R] =
  let shape = mat.shape
  result = newMatrix[R](shape[0],shape[1])
  for idx,v in mat:
    result[idx] = f(v)

func transpose*[T](mat:Matrix[T]):Matrix[T] = 
  let shape = mat.shape
  result = newMatrix[T](shape[1],shape[0])
  for i,v in mat:
    for j,c in v:
      result[j][i] = c

func flatten*[T](mat:Matrix[T]):Vector[T]=
  let shape = mat.shape
  let size = shape[0] * shape[1]
  result = newVector[T](size)
  for idx,v in mat:
    for j,c in v:
      result[idx*shape[0] + j] = c

func dot*[T](mat1:Matrix[T],mat2:Matrix[T]):Matrix[T]=
  let t_mat2 = mat2.transpose
  result = newMatrix[T](mat1.shape()[1],mat2.shape()[0])
  for i,v1 in mat1:
    for j,v2 in t_mat2:
      result[i][j] = v1 @ v2

func `@`*[T](mat1:Matrix[T],mat2:Matrix[T]):Matrix[T] = mat1.dot(mat2)

func dot*[T](vec:Vector[T],mat:Matrix[T]):Matrix[T]=
  newMatrix(vec).dot(mat)
  
func `@`*[T](vec:Vector[T],mat:Matrix[T]):Matrix[T]= vec.dot(mat)

# ------------------------------------------
# test
# ------------------------------------------
when isMainModule:
  #let m1 = newMatrix(@[@[1.0,2.0,3.0,4.0],@[4.0,5.0,6.0,7.0]])
  #let m2 = newMatrix(@[@[1.0,2.0],@[3.0,4.0],@[4.0,5.0],@[6.0,7.0]])
  #let m1 = newMatrix(@[@[1,2,3,4],@[4,5,6,7]])
  #let m2 = newMatrix(@[@[1,2],@[3,4],@[4,5],@[6,7]])

  let v1 = newVector([1,2,3,4,5])
  let v2 = newVector([6.0,7.0,8.0])

  echo v2.map(proc (x:float):float = x + 1)

