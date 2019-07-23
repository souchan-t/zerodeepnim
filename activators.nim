{.experimental.}
import vectors
import functions

type
  Activator* = ref object of RootObj
    activate*:proc (x:Vector[float]):Vector[float]

  SigmoidActivator* = ref object of Activator
  LinearActivator* = ref object of Activator
  StepActivator* = ref object of Activator

#Sigmoid Activator
func newSigmoidActivator*(gain:float = 1.0):SigmoidActivator=
  result = new SigmoidActivator
  result.activate = proc (x:Vector[float]):Vector[float] = 
    x.map(sigmoidCurried(gain))

#Linear Activator
func newLinearActivator*():LinearActivator=
  result = new LinearActivator
  result.activate = proc (x:Vector[float]):Vector[float] = 
    x.map(linear)

#Step Activator
func newStepActivator*(thre=0.5):StepActivator = 
  result = new StepActivator
  result.activate = proc (x:Vector[float]):Vector[float] = 
    x.map(stepCurried(0.5))


when isMainModule:
  let a1 = newSigmoidActivator()
  let v1 = newVector([1.0,2.0,3.0])
  echo a1.activate(v1)
