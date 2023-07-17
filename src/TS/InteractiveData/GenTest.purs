module TS.InteractiveData.GenTest where

import Prelude

import DTS as DTS
import Data.Either (Either)
import Prim.Row as Row
import Record as Record
import TS.InteractiveData.TsBridge.Class (Tok(..))
import TsBridge as TSB
import Unsafe.Coerce (unsafeCoerce)

-- x :: String
-- x = ""

-- foreign import data R1 :: forall k. Row k
-- foreign import data R2 :: forall k. Row k
-- foreign import data R3 :: forall k. Row k


-- instance Row.Union R1 R2 R3

-- foo :: forall r1 r2 r3. Row.Union r1 r2 r3 => Record r1 -> Record r2 -> Record r3
-- foo = Record.union 

---

moduleName :: String
moduleName = "TS.InteractiveData.GenTest"

tsModules :: Either TSB.AppError (Array DTS.TsModuleFile)
tsModules =
  TSB.tsModuleFile moduleName
    [ TSB.tsValues Tok
        { 
        }
    ]