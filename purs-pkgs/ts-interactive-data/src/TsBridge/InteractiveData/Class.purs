module TsBridge.InteractiveData.Class where

import Prelude

import Chameleon.Impl.ReactBasic (ReactHtml)
import Chameleon.Impl.ReactBasic as Chameleon.Impl.ReactBasic
import DTS as DTS
import Data.Array.NonEmpty as Data.Array.NonEmpty
import Data.Either (Either)
import Data.Function.Uncurried (Fn2)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable)
import Data.Symbol (class IsSymbol)
import Data.These (These)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import DataMVC.Types as DataMVC.Types
import DataMVC.Types as MVC.Types
import Effect (Effect)
import InteractiveData (IDSurface)
import InteractiveData as InteractiveData
import InteractiveData.App as InteractiveData.App
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.App.WrapData as InteractiveData.App.WrapData
import InteractiveData.Core as InteractiveData.Core
import InteractiveData.Core.Types.IDHtmlT (IDHtmlT)
import InteractiveData.Core.Types.IDHtmlT as InteractiveData.Core.Types.IDHtmlT
import Literals.Null (Null)
import React.Basic as React.Basic
import TsBridge (class TsBridgeBy, TsBridgeM, TsRecord, TypeVar, tsBridgeBy)
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

instance TsBridge MVC.Types.DataError where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "MVC.Types"
    , typeName: "DataError"
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

instance TsBridge InteractiveData.NumberState where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData"
    , typeName: "NumberState"
    , typeArgs: []
    }

instance TsBridge InteractiveData.NumberMsg where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData"
    , typeName: "NumberMsg"
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
--- Chameleon.Impl.ReactBasic
--------------------------------------------------------------------------------

instance (TsBridge msg) => TsBridge (Chameleon.Impl.ReactBasic.ReactHtml msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "Chameleon.Impl.ReactBasic"
    , typeName: "ReactHtml"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

--------------------------------------------------------------------------------
--- InteractiveData.Core
--------------------------------------------------------------------------------

instance (TsBridge msg) => TsBridge (InteractiveData.Core.DataTree (IDHtmlT ReactHtml) msg) where
  tsBridge _ = TSB.tsBridgeNewtype Tok
    { moduleName: "InteractiveData.Core"
    , typeName: "DataTree"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }
    (Proxy :: Proxy (InteractiveData.Core.DataTree (IDHtmlT ReactHtml) msg))

instance TsBridge InteractiveData.Core.IDOutMsg where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core"
    , typeName: "IDOutMsg"
    , typeArgs: []
    }

instance (TsBridge msg) => TsBridge (InteractiveData.Core.DataAction msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core"
    , typeName: "DataAction"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

instance (TsBridge msg) => TsBridge (InteractiveData.Core.DataTreeChildren (IDHtmlT ReactHtml) msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core"
    , typeName: "DataTreeChildren"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

instance (TsBridge msg) => TsBridge (InteractiveData.Core.Types.IDHtmlT.IDHtmlT ReactHtml msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core"
    , typeName: "IDHtmlT"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

instance
  TsBridge InteractiveData.Core.ViewMode
  where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.Core"
    , typeName: "ViewMode"
    , typeArgs: []
    }

--------------------------------------------------------------------------------
--- InteractiveData.App.WrapData
--------------------------------------------------------------------------------

instance (TsBridge sta) => TsBridge (InteractiveData.App.WrapData.WrapState sta) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.App.WrapData"
    , typeName: "WrapState"
    , typeArgs: [ "sta" /\ tsBridge (Proxy :: _ sta) ]
    }

instance (TsBridge msg) => TsBridge (InteractiveData.App.WrapData.WrapMsg msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.App.WrapData"
    , typeName: "WrapMsg"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

--------------------------------------------------------------------------------
--- InteractiveData.App
--------------------------------------------------------------------------------

instance (TsBridge sta) => TsBridge (InteractiveData.App.AppState sta) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.App"
    , typeName: "AppState"
    , typeArgs: [ "sta" /\ tsBridge (Proxy :: _ sta) ]
    }

instance (TsBridge msg) => TsBridge (InteractiveData.App.AppSelfMsg msg) where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "InteractiveData.App"
    , typeName: "AppSelfMsg"
    , typeArgs: [ "msg" /\ tsBridge (Proxy :: _ msg) ]
    }

--------------------------------------------------------------------------------
--- React.Basic
--------------------------------------------------------------------------------

instance TsBridge React.Basic.JSX where
  tsBridge _ = pure $
    DTS.TsTypeConstructor
      (DTS.TsQualName (Just (DTS.TsImportPath "react")) (DTS.TsName "ReactNode"))
      (DTS.TsTypeArgs [])

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

instance (TsBridge a1, TsBridge a2, TsBridge b) => TsBridge (Fn2 a1 a2 b) where
  tsBridge = TSB.tsBridgeFn2 Tok

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

instance (TsBridge a, TsBridge b) => TsBridge (These a b) where
  tsBridge = tsBridgeThese Tok

instance TsBridge a => TsBridge (Maybe a) where
  tsBridge = TSB.tsBridgeMaybe Tok

instance TsBridge a => TsBridge (Nullable a) where
  tsBridge = TSB.tsBridgeNullable Tok

instance TsBridge a => TsBridge (Effect a) where
  tsBridge = TSB.tsBridgeEffect Tok

instance (TsBridge a, TsBridge b) => TsBridge (Tuple a b) where
  tsBridge = TSB.tsBridgeTuple Tok

--------------------------------------------------------------------------------
--- Data.Array.NonEmpty
--------------------------------------------------------------------------------

instance
  TsBridge a =>
  TsBridge (Data.Array.NonEmpty.NonEmptyArray a)
  where
  tsBridge = TSB.tsBridgeOpaqueType
    { moduleName: "Data.Array.NonEmpty"
    , typeName: "NonEmptyArray"
    , typeArgs: [ "a" /\ tsBridge (Proxy :: _ a) ]
    }

--------------------------------------------------------------------------------

tsBridgeThese
  :: forall tok a b
   . TsBridgeBy tok a
  => TsBridgeBy tok b
  => tok
  -> Proxy (These a b)
  -> TsBridgeM DTS.TsType
tsBridgeThese tok =
  TSB.tsBridgeOpaqueType
    { moduleName: "Data.These"
    , typeName: "These"
    , typeArgs:
        [ "A" /\ tsBridgeBy tok (Proxy :: _ a)
        , "B" /\ tsBridgeBy tok (Proxy :: _ b)
        ]
    }