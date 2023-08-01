module TS.InteractiveData where

import Prelude

import TsBridge.InteractiveData.Class (Tok(..))
import TsBridge (TypeVar)
import TsBridge as TSB
import Data.Either (Either)
import DTS as DTS

---

dataUi :: String
dataUi = "data-ui-purs"

moduleName :: String
moduleName = "TS.InteractiveData"

type VarMsg = TypeVar "msg"
type VarSta = TypeVar "sta"
type VarA = TypeVar "a"
type VarB = TypeVar "b"

tsModules :: Either TSB.AppError (Array DTS.TsModuleFile)
tsModules =
  TSB.tsModuleFile moduleName
    [ TSB.tsValues Tok
        { dataUi
        }
    ]