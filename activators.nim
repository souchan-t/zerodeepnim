import vector
import functions

type
  Activator = ref object of RootObj
    activate:proc (x:Vector):Vector

  SigmoidActivator = ref object of Activator
  LinearActivator = ref object of Activator
  StepActivator = ref object of Activator

#Sigmoid Activator
proc newSigmoidActivator*(gain:float = 1.0):Activator=
  result = new SigmoidActivator
  result.activate = proc (x:Vector):Vector = 
    x.map(sigmoidCurried(gain))

#Linear Activator
proc newLinearActivator*():Activator=
  result = new LinearActivator
  result.activate = proc (x:Vector):Vector = 
    x.map(linear)

#Step Activator
proc newStepActivator*(thre=0.5):Activator = 
  result = new StepActivator
  result.activate = proc (x:Vector):Vector = 
    x.map(stepCurried(0.5))
