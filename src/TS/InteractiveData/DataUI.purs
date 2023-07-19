module TS.InteractiveData.DataUI where

import Prelude

import DTS as DTS
import Data.Either (Either(..))
import Effect (Effect)
import InteractiveData (IDDataUI, IDHtmlT, StringMsg, StringState, WrapMsg, WrapState)
import InteractiveData as I
import InteractiveData.Core.Types (IDError(..))
import InteractiveData.DataUI as DUI
import InteractiveData.DataUI.NavigationWrapper (AppMsg, AppState)
import LabeledData.VariantLike.Class (EitherV, fromVariant, toVariant)
import MVC.Types (UI)
import React.Basic (JSX)
import TS.InteractiveData.TsBridge.Class (Tok(..))
import TsBridge (TypeVar)
import TsBridge as TSB
import VirtualDOM.Impl.ReactBasic (ReactHtml)
import VirtualDOM.Impl.ReactBasic as R

---

dataUiString_ :: IDDataUI (IDHtmlT ReactHtml) StringMsg StringState String
dataUiString_ = DUI.dataUiString_

---

toUI
  :: forall msg sta a
   . { initData :: Either IDError a
     , name :: String
     }
  -> IDDataUI (IDHtmlT ReactHtml) msg sta a
  -> { extract :: AppState (WrapState sta) -> Either IDError a
     , ui :: UI ReactHtml (AppMsg (WrapMsg msg)) (AppState (WrapState sta))
     }
toUI = I.toUI

---

uiToReactComponent
  :: forall msg sta
   . { onStateChange :: sta -> Effect Unit
     }
  -> UI ReactHtml msg sta
  -> Effect (Record () -> JSX)
uiToReactComponent = R.uiToReactComponent

mountAtId :: String -> Effect (Record () -> JSX) -> Effect Unit
mountAtId = R.mountAtId

notYetDefined :: forall a. Unit -> Either IDError a
notYetDefined _ = Left $ IDErrNotYetDefined

toEitherV :: forall a b. Either a b -> EitherV a b
toEitherV = toVariant

fromEitherV :: forall a b. EitherV a b -> Either a b
fromEitherV = fromVariant

---

eqEither :: forall a b. (a -> a -> Boolean) -> (b -> b -> Boolean) -> Either a b -> Either a b -> Boolean
eqEither eqA eqB a b = case a, b of
  Left a1, Left a2 -> eqA a1 a2
  Right b1, Right b2 -> eqB b1 b2
  _, _ -> false

---

moduleName :: String
moduleName = "TS.InteractiveData.DataUI"

type VarMsg = TypeVar "msg"
type VarSta = TypeVar "sta"
type VarA = TypeVar "a"
type VarB = TypeVar "b"

tsModules :: Either TSB.AppError (Array DTS.TsModuleFile)
tsModules =
  TSB.tsModuleFile moduleName
    [ TSB.tsValues Tok
        { toUI: toUI :: _ -> _ _ VarMsg VarSta VarA -> _
        , dataUiString_
        , uiToReactComponent: uiToReactComponent :: _ -> UI _ VarMsg VarSta -> _
        , mountAtId
        , notYetDefined: notYetDefined :: _ -> _ _ VarA
        , toEitherV: toEitherV :: _ VarA VarB -> _
        , fromEitherV: fromEitherV :: _ -> _ VarA VarB
        }
    ]