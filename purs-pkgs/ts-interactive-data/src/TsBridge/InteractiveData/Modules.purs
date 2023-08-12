module TsBridge.InteractiveData.Modules where

import DTS as DTS
import Data.Either (Either)
import TS.InteractiveData.DataUIs as TS.InteractiveData.DataUIs
import TS.InteractiveData.DataUtil as TS.InteractiveData.DataUtil
import TS.InteractiveData.React as TS.InteractiveData.React
import TS.InteractiveData.Run as TS.InteractiveData.Run
import TsBridge as TSB

tsProgram :: Either TSB.AppError DTS.TsProgram
tsProgram =
  TSB.tsProgram
    [ TS.InteractiveData.DataUtil.tsModules
    , TS.InteractiveData.DataUIs.tsModules
    , TS.InteractiveData.React.tsModules
    , TS.InteractiveData.Run.tsModules
    ]