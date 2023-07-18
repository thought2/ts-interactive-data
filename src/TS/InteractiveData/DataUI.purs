module TS.InteractiveData.DataUI where

import Prelude

import DTS as DTS
import Data.Either (Either(..))
import Effect (Effect)
import InteractiveData (DataPathSegment, DataTree(..), IDDataUI, IDHtml(..), RecordMsg, RecordState, StringMsg, StringState, WrapMsg, WrapState)
import InteractiveData as I
import InteractiveData.Core.Record.DataUI (class DataUiRecord)
import InteractiveData.Core.Types (DataUI, Error(..))
import InteractiveData.DataUI as DUI
import InteractiveData.DataUI.NavigationWrapper (AppMsg, AppState)
import LabeledData.VariantLike.Class (EitherV, fromVariant, toVariant)
import MVC.Types (UI)
import React.Basic (JSX)
import TS.InteractiveData.TsBridge.Class (Tok(..))
import TsBridge (TypeVar(..))
import TsBridge as TSB
import VirtualDOM.Impl.ReactBasic (ReactHtml)
import VirtualDOM.Impl.ReactBasic as R
import VirtualDOM.Transformers.Ctx.Trans (CtxT(..))

---

dataUiString_ :: IDDataUI (IDHtml ReactHtml) StringMsg StringState String
dataUiString_ = DUI.dataUiString_

---

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

toEitherV :: forall a b. Either a b -> EitherV a b
toEitherV = toVariant

fromEitherV :: forall a b. EitherV a b -> Either a b
fromEitherV = fromVariant

---

moduleName :: String
moduleName = "TS.InteractiveData.DataUI"

tsModules :: Either TSB.AppError (Array DTS.TsModuleFile)
tsModules =
  TSB.tsModuleFile moduleName
    [ TSB.tsValues Tok
        { toUI: toUI :: _ -> (_ _ (TypeVar "msg") (TypeVar "sta") (TypeVar "a")) -> _
        , dataUiString_
        , uiToReactComponent: uiToReactComponent :: _ -> (UI _ (TypeVar "msg") (TypeVar "sta")) -> _
        , mountAtId
        , notYetDefined: notYetDefined :: _ -> _ _ (TypeVar "a")
        , toEitherV : toEitherV :: _ (TypeVar "a") (TypeVar "b") -> _
        , fromEitherV : fromEitherV :: _ -> _ (TypeVar "a") (TypeVar "b")
        }
    ]