module TS.InteractiveData.TsBridge.Class where

import Prelude

import Control.Promise (Promise)
import DTS as DTS
import Data.Either (Either)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Symbol (class IsSymbol)
import Data.These (These)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Data.Variant (Variant)
import Effect (Effect)
import InteractiveData (DataPathSegment, DataTree, IDHtml, IDOutMsg, IDSurface, Proxy(..), StringMsg, StringState, WrapMsg, WrapState)
import InteractiveData.Core.Types (DataUI, DataUICtx, DataUiItf, Error)
import InteractiveData.DataUI.NavigationWrapper (AppState, SelfMsg)
import React.Basic (JSX)
import TsBridge (TypeVar)
import TsBridge as TSB
import Type.Proxy (Proxy)
import VirtualDOM.Impl.ReactBasic (ReactHtml)

class TsBridge (a :: Type) where
  tsBridge :: Proxy a -> TSB.TsBridgeM DTS.TsType

data Tok = Tok

instance TsBridge a => TSB.TsBridgeBy Tok a where
  tsBridgeBy _ = tsBridge

---

type VarMsg = (TypeVar "msg")
type VarSta = (TypeVar "sta")
type VarA = (TypeVar "a")

---

instance
  ( TsBridge msg
  , TsBridge sta
  , TsBridge a
  ) =>
  TsBridge
    (DataUI (IDSurface (IDHtml ReactHtml)) WrapMsg WrapState msg sta a)
  where
  tsBridge _ = TSB.tsBridgeNewtype Tok
    { moduleName: "InteractiveData.Core.Types"
    , typeName: "DataUI"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg)
        , "sta" /\ tsBridge (Proxy :: _ sta)
        , "a" /\ tsBridge (Proxy :: _ a)
        ]
    }
    (Proxy :: _ (DataUI (IDSurface (IDHtml ReactHtml)) WrapMsg WrapState VarMsg VarSta VarA))

instance
  ( TsBridge msg
  ) =>
  TsBridge (IDSurface (IDHtml ReactHtml) msg)
  where
  tsBridge _ = TSB.tsBridgeNewtype Tok
    { moduleName: "InteractiveData.Core.Types"
    , typeName: "IDSurface"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }
    (Proxy :: _ (IDSurface (IDHtml ReactHtml) VarMsg))

instance
  TsBridge (DataUICtx (IDSurface (IDHtml ReactHtml)) WrapMsg WrapState) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core.Types"
    , typeName: "DataUICtx"
    , typeArgs: []
    }

instance
  ( TsBridge sta
  , TsBridge a
  , TsBridge msg
  ) =>
  TsBridge (DataUiItf (IDSurface (IDHtml ReactHtml)) msg sta a) where
  tsBridge _ = TSB.tsBridgeNewtype Tok
    { moduleName: "InteractiveData.Core.Types"
    , typeName: "DataUiItf"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg)
        , "sta" /\ tsBridge (Proxy :: _ sta)
        , "a" /\ tsBridge (Proxy :: _ a)
        ]
    }
    (Proxy :: _ (DataUiItf (IDSurface (IDHtml ReactHtml)) VarMsg VarSta VarA))

instance (TsBridge msg) => TsBridge (ReactHtml msg) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:ReactHtml"

instance (TsBridge msg) => TsBridge (IDHtml ReactHtml msg) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:IDHtml ReactHtml"

instance TsBridge JSX where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:JSX"

instance TsBridge Error where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core.Types"
    , typeName: "Error"
    , typeArgs: []
    }

instance (TsBridge msg) => TsBridge (WrapMsg msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Types"
    , typeName: "WrapMsg"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

instance (TsBridge msg) => TsBridge (SelfMsg msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.DataUI.NavigationWrapper"
    , typeName: "SelfMsg"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

instance (TsBridge sta) => TsBridge (WrapState sta) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Types"
    , typeName: "WrapState"
    , typeArgs: [ "sta" /\ tsBridge (Proxy :: _ sta) ]
    }

instance (TsBridge sta) => TsBridge (AppState sta) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.DataUI.NavigationWrapper"
    , typeName: "AppState"
    , typeArgs: [ "sta" /\ tsBridge (Proxy :: _ sta) ]
    }

instance TsBridge StringState where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.DataUI.String"
    , typeName: "StringState"
    , typeArgs: []
    }

instance TsBridge StringMsg where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.DataUI.String"
    , typeName: "StringMsg"
    , typeArgs: []
    }

instance TsBridge IDOutMsg where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Types.DataTree"
    , typeName: "IDOutMsg"
    , typeArgs: []
    }

instance (TsBridge msg) => TsBridge (DataTree ((IDHtml ReactHtml)) msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Types.DataTree"
    , typeName: "DataTree"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

instance TsBridge DataPathSegment where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Types.DataTree"
    , typeName: "DataPathSegment"
    , typeArgs: []
    }

instance (TsBridge a, TsBridge b) => TsBridge (These a b) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "Data.These"
    , typeName: "These"
    , typeArgs:
        [ "A" /\ tsBridge (Proxy :: _ a)
        , "B" /\ tsBridge (Proxy :: _ b)
        ]
    }

---

instance (TsBridge a, TsBridge b) => TsBridge (Either a b) where
  tsBridge = TSB.tsBridgeEither Tok

instance (TsBridge a, TsBridge b) => TsBridge (Tuple a b) where
  tsBridge = TSB.tsBridgeTuple Tok

instance TsBridge Number where
  tsBridge = TSB.tsBridgeNumber

instance (TSB.TsBridgeRecord Tok r) => TsBridge (Record r) where
  tsBridge = TSB.tsBridgeRecord Tok

instance (TSB.TsBridgeVariant Tok r) => TsBridge (Variant r) where
  tsBridge = TSB.tsBridgeVariant Tok

instance TsBridge String where
  tsBridge = TSB.tsBridgeString

instance TsBridge Boolean where
  tsBridge = TSB.tsBridgeBoolean

instance TsBridge Int where
  tsBridge = TSB.tsBridgeInt

instance TsBridge Char where
  tsBridge = TSB.tsBridgeChar

instance TsBridge Unit where
  tsBridge = TSB.tsBridgeUnit

instance TsBridge a => TsBridge (Array a) where
  tsBridge = TSB.tsBridgeArray Tok

instance TsBridge a => TsBridge (Effect a) where
  tsBridge = TSB.tsBridgeEffect Tok

instance TsBridge a => TsBridge (Nullable a) where
  tsBridge = TSB.tsBridgeNullable Tok

instance (TsBridge a, TsBridge b) => TsBridge (a -> b) where
  tsBridge = TSB.tsBridgeFunction Tok

instance TsBridge a => TsBridge (Maybe a) where
  tsBridge = TSB.tsBridgeMaybe Tok

instance TsBridge a => TsBridge (Promise a) where
  tsBridge = TSB.tsBridgePromise Tok

instance IsSymbol sym => TsBridge (TSB.TypeVar sym) where
  tsBridge = TSB.tsBridgeTypeVar