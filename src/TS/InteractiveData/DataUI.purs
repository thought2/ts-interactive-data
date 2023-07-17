module TS.InteractiveData.DataUI where

import Prelude

import DTS as DTS
import Data.Either (Either(..))
import Effect (Effect)
import InteractiveData (IDDataUI, IDHtml, StringMsg, StringState, WrapMsg, WrapState)
import InteractiveData as I
import InteractiveData.Core.Types (Error(..))
import InteractiveData.DataUI as DUI
import InteractiveData.DataUI.NavigationWrapper (AppMsg, AppState)
import MVC.Types (UI)
import React.Basic (JSX)
import TS.InteractiveData.TsBridge.Class (Tok(..))
import TsBridge (TypeVar(..))
import TsBridge as TSB
import VirtualDOM.Impl.ReactBasic (ReactHtml)
import VirtualDOM.Impl.ReactBasic as R

---

dataUiString_ :: IDDataUI (IDHtml ReactHtml) StringMsg StringState String
dataUiString_ = DUI.dataUiString_

toUI
  :: forall msg sta a
   . { initData :: Either Error a
     , name :: String
     }
  -> IDDataUI (IDHtml ReactHtml) msg sta a
  -> { extract :: AppState (WrapState sta) -> Either Error a
     , ui :: UI ReactHtml (AppMsg (WrapMsg msg)) (AppState (WrapState sta))
     }
toUI = I.toUI

---

x = toUI
  { initData: Right "hello"
  , name: "hello"
  }
  dataUiString_

uiToReactComponent
  :: forall msg sta
   . { onStateChange :: sta -> Effect Unit
     }
  -> UI ReactHtml msg sta
  -> Effect (Record () -> JSX)
uiToReactComponent = R.uiToReactComponent

mountAtId :: String -> Effect (Record () -> JSX) -> Effect Unit
mountAtId = R.mountAtId

notYetDefined :: forall a. Unit -> Either Error a
notYetDefined _ = Left $ ErrNotYetDefined

y = x.ui
  # R.uiToReactComponent
      { onStateChange: \_ -> pure unit
      }
  # R.mountAtId "root"

---

moduleName :: String
moduleName = "TS.InteractiveData.DataUI"

tsModules :: Either TSB.AppError (Array DTS.TsModuleFile)
tsModules =
  TSB.tsModuleFile moduleName
    [ TSB.tsValues Tok
        { toUI: toUI :: _ -> (_ _ (TypeVar "Msg") (TypeVar "Sta") (TypeVar "A")) -> _
        , dataUiString_
        , uiToReactComponent: uiToReactComponent :: _ -> (UI _ (TypeVar "Msg") (TypeVar "Sta")) -> _
        , mountAtId
        , notYetDefined: notYetDefined :: _ -> _ _ (TypeVar "A")
        }
    ]