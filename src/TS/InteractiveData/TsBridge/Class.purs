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
import InteractiveData (DataPathSegment, DataTree, IDHtml(..), IDOutMsg, Proxy(..), StringMsg, StringState, WrapMsg, WrapState)
import InteractiveData.Core.Types (DataUI, DataUICtx, DataUiItf, Error)
import InteractiveData.DataUI.NavigationWrapper (AppState(..), SelfMsg)
import React.Basic (JSX)
import TsBridge as TSB
import Type.Proxy (Proxy)
import VirtualDOM.Impl.ReactBasic (ReactHtml)
import VirtualDOM.Transformers.Ctx.Trans (CtxT)

class TsBridge (a :: Type) where
  tsBridge :: Proxy a -> TSB.TsBridgeM DTS.TsType

data Tok = Tok

instance TsBridge a => TSB.TsBridgeBy Tok a where
  tsBridgeBy _ = tsBridge

---

--- todo:
-- get rid of CtxT, create IDSurface newtype

instance
  ( TsBridge sta
  , TsBridge a
  , TsBridge msg
  , TsBridge ctx
  ) =>
  TsBridge
    (DataUI (CtxT ctx (DataTree (IDHtml ReactHtml))) WrapMsg WrapState msg sta a)
  where
  tsBridge = TSB.tsBridgeNewtype Tok
    { moduleName: "InteractiveData.Core.Types"
    , typeName: "DataUI"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg)
        , "sta" /\ tsBridge (Proxy :: _ sta)
        , "a" /\ tsBridge (Proxy :: _ a)
        ]
    }

instance
  ( TsBridge ctx

  ) =>
  TsBridge (DataUICtx (CtxT ctx (DataTree (IDHtml ReactHtml))) WrapMsg WrapState) where
  tsBridge _ = pure $ DTS.TsTypeBoolean

instance
  ( TsBridge sta
  , TsBridge a
  , TsBridge msg
  --, TsBridge (ReactHtml msg)
  , TsBridge ctx

  ) =>
  TsBridge (DataUiItf (CtxT ctx (DataTree (IDHtml ReactHtml))) msg sta a) where
  tsBridge = TSB.tsBridgeNewtype Tok
    { moduleName: "InteractiveData.Core.Types"
    , typeName: "DataUiItf"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg)
        , "sta" /\ tsBridge (Proxy :: _ sta)
        , "a" /\ tsBridge (Proxy :: _ a)
        ]
    }

instance (TsBridge msg) => TsBridge (ReactHtml msg) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:ReactHtml"

instance (TsBridge msg) => TsBridge (IDHtml ReactHtml msg) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:IDHtml ReactHtml"

instance TsBridge Error where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:error"

instance (TsBridge msg) => TsBridge (WrapMsg msg) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:WrapMsg"


instance (TsBridge msg) => TsBridge (SelfMsg msg) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:SelfMsg"


instance  TsBridge JSX where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:JSX"

instance (TsBridge sta) => TsBridge (WrapState sta) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:WrapState"

instance (TsBridge sta) => TsBridge (AppState sta) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:AppState"

instance TsBridge StringState where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:StringState"

instance TsBridge StringMsg where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:StringMsg"


instance TsBridge IDOutMsg where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:IDOutMsg"


instance TsBridge (CtxT ctx html a) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:CtxT"

instance (TsBridge msg) => TsBridge (DataTree ReactHtml msg) where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:DataTree"

instance TsBridge DataPathSegment where
  tsBridge _ = pure $ DTS.TsTypeTypelevelString "todo:DataPathSegment"

-- TSB.tsBridgeNewtype Tok {
--   moduleName: "VirtualDOM.Transformers.Ctx.Trans",
--   typeName: "CtxT",
--   typeArgs: []
-- } 

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