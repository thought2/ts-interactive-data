module TsBridge.InteractiveData.Modules where

import DTS as DTS
import Data.Either (Either)
import Data.Either as Data.Either
import Data.Int as Data.Int
import Data.Nullable as Data.Nullable
import TS.InteractiveData as TS.InteractiveData
import TsBridge.InteractiveData.Class (Tok(..))
import TsBridge as TSB

tsProgram :: Either TSB.AppError DTS.TsProgram
tsProgram =
  TSB.tsProgram
    [ TS.InteractiveData.tsModules
    ]