module TS.InteractiveData.TsBridge.Modules where

import DTS as DTS
import Data.Either (Either)
import Data.Int as Data.Int
import Data.Nullable as Data.Nullable
import TS.InteractiveData.TsBridge.Class (Tok(..))
import TsBridge as TSB
import TS.InteractiveData.DataUI as TS.InteractiveData.DataUI

myTsProgram :: Either TSB.AppError DTS.TsProgram
myTsProgram =
  TSB.tsProgram
    [ TS.InteractiveData.DataUI.tsModules
    , TSB.tsModuleFile "Data.Int"
        [ TSB.tsValues Tok
            { fromNumber: Data.Int.fromNumber
            , round: Data.Int.round
            }
        ]
    , TSB.tsModuleFile "Data.Nullable"
        [ TSB.tsValues Tok
            { toNullable: Data.Nullable.toNullable :: _ (TSB.TypeVar "A") -> _
            , toMaybe: Data.Nullable.toMaybe :: _ (TSB.TypeVar "A") -> _
            }
        ]
    ]