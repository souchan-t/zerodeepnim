{.experimental.}

import math
import random
import strformat
import functions
import vectors
import activators

let x = newMatrix(@[@[1.0,0.5]])
let w1 = newMatrix(@[@[0.1,0.3,0.5],@[0.2,0.4,0.6]])
let b1 = newVector([0.1,0.2,0.3])

echo x.dot(w1) 


