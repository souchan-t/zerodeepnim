import vectors
import functions

type
  Activator = ref object of RootObj
    activate:proc (x:Vector[float]):Vector[float]

  SigmoidActivator = ref object of Activator
  LinearActivator = ref object of Activator
  StepActivator = ref object of Activator

#Sigmoid Activator
func newSigmoidActivator*(gain:float = 1.0):Activator=
  result = new SigmoidActivator
  result.activate = proc (x:Vector[float]):Vector[float] = 
    x.map(sigmoidCurried(gain))

#Linear Activator
func newLinearActivator*():Activator=
  result = new LinearActivator
  result.activate = proc (x:Vector[float]):Vector[float] = 
    x.map(linear)

#Step Activator
func newStepActivator*(thre=0.5):Activator = 
  result = new StepActivator
  result.activate = proc (x:Vector[float]):Vector[float] = 
    x.map(stepCurried(0.5))
