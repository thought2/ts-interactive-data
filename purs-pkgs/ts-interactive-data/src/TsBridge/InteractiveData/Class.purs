module TsBridge.InteractiveData.Class where

import Prelude

import Chameleon.Impl.ReactBasic (ReactHtml)
import DTS as DTS
import Data.Array.NonEmpty as Data.Array.NonEmpty
import Data.Either (Either)
import Data.Maybe (Maybe)
import Data.Symbol (class IsSymbol)
import Data.Tuple.Nested ((/\))
import DataMVC.Types as DataMVC.Types
import InteractiveData (IDSurface)
import InteractiveData as InteractiveData
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.Core as InteractiveData.Core
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import Literals.Null (Null)
import TsBridge (TsRecord, TypeVar)
import TsBridge as TSB
import Type.Proxy (Proxy(..))
import Untagged.Union (OneOf)

class TsBridge (a :: Type) where
  tsBridge :: Proxy a -> TSB.TsBridgeM DTS.TsType

data Tok = Tok

instance TsBridge a => TSB.TsBridgeBy Tok a where
  tsBridgeBy _ = tsBridge

--------------------------------------------------------------------------------
--- Type Variables
--------------------------------------------------------------------------------

type VarMsg = (TypeVar "msg")

type VarSta = (TypeVar "sta")

type VarA = (TypeVar "a")

--------------------------------------------------------------------------------
--- DataMVC.Types
--------------------------------------------------------------------------------

instance
  ( TsBridge msg
  , TsBridge sta
  , TsBridge a
  ) =>
  TsBridge
    (DataMVC.Types.DataUI (IDSurface (IDHtmlT ReactHtml)) WrapMsg WrapState msg sta a)
  where
  tsBridge _ = TSB.tsBridgeNewtype Tok
    { moduleName: "DataMVC.Types"
    , typeName: "DataUI"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg)
        , "sta" /\ tsBridge (Proxy :: _ sta)
        , "a" /\ tsBridge (Proxy :: _ a)
        ]
    }
    ( Proxy
        :: Proxy
             ( DataMVC.Types.DataUI
                 (IDSurface (IDHtmlT ReactHtml))
                 WrapMsg
                 WrapState
                 VarMsg
                 VarSta
                 VarA
             )
    )

instance
  TsBridge (DataMVC.Types.DataUICtx (IDSurface (IDHtmlT ReactHtml)) WrapMsg WrapState)
  where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "DataMVC.Types"
    , typeName: "DataUICtx"
    , typeArgs: []
    }

instance
  ( TsBridge sta
  , TsBridge a
  , TsBridge msg
  ) =>
  TsBridge (DataMVC.Types.DataUiInterface (IDSurface (IDHtmlT ReactHtml)) msg sta a)
  where
  tsBridge _ = TSB.tsBridgeNewtype Tok
    { moduleName: "DataMVC.Types"
    , typeName: "DataUiInterface"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg)
        , "sta" /\ tsBridge (Proxy :: _ sta)
        , "a" /\ tsBridge (Proxy :: _ a)
        ]
    }
    ( Proxy
        :: Proxy
             ( DataMVC.Types.DataUiInterface
                 (IDSurface (IDHtmlT ReactHtml))
                 VarMsg
                 VarSta
                 VarA
             )
    )

instance TsBridge DataMVC.Types.DataPathSegment where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "DataMVC.Types"
    , typeName: "DataPathSegment"
    , typeArgs: []
    }

--------------------------------------------------------------------------------
--- InteractiveData
--------------------------------------------------------------------------------

instance TsBridge InteractiveData.StringState where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData"
    , typeName: "StringState"
    , typeArgs: []
    }

instance TsBridge InteractiveData.StringMsg where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData"
    , typeName: "StringMsg"
    , typeArgs: []
    }

instance
  ( TsBridge msg
  ) =>
  TsBridge (InteractiveData.IDSurface (IDHtmlT ReactHtml) msg)
  where
  tsBridge _ = TSB.tsBridgeNewtype Tok
    { moduleName: "InteractiveData"
    , typeName: "IDSurface"
    , typeArgs:
        [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }
    (Proxy :: _ (InteractiveData.IDSurface (IDHtmlT ReactHtml) VarMsg))

--------------------------------------------------------------------------------
--- InteractiveData.Core
--------------------------------------------------------------------------------

instance (TsBridge msg) => TsBridge (InteractiveData.Core.DataTree (IDHtmlT ReactHtml) msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core"
    , typeName: "DataTree"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

--------------------------------------------------------------------------------

instance TsBridge Number where
  tsBridge = TSB.tsBridgeNumber

instance (TSB.TsBridgeRecord Tok r) => TsBridge (Record r) where
  tsBridge = TSB.tsBridgeRecord Tok

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

instance (TsBridge a, TsBridge b) => TsBridge (a -> b) where
  tsBridge = TSB.tsBridgeFunction Tok

instance IsSymbol sym => TsBridge (TSB.TypeVar sym) where
  tsBridge = TSB.tsBridgeTypeVar

instance (TSB.TsBridgeTsRecord Tok r) => TsBridge (TsRecord r) where
  tsBridge = TSB.tsBridgeTsRecord Tok

instance (TsBridge a, TsBridge b) => TsBridge (OneOf a b) where
  tsBridge = TSB.tsBridgeOneOf Tok

instance TsBridge Null where
  tsBridge = TSB.tsBridgeNull

instance (TsBridge a, TsBridge b) => TsBridge (Either a b) where
  tsBridge = TSB.tsBridgeEither Tok

instance TsBridge a => TsBridge (Maybe a) where
  tsBridge = TSB.tsBridgeMaybe Tok

--------------------------------------------------------------------------------
--- Data.Array.NonEmpty
--------------------------------------------------------------------------------

instance
  TsBridge (Data.Array.NonEmpty.NonEmptyArray a)
  where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "Data.Array.NonEmpty"
    , typeName: "NonEmptyArray"
    , typeArgs: [] -- TODO
    }