module TS.InteractiveData.Run
  ( toApp
  , tsModules
  ) where

import Prelude

import Chameleon.Impl.ReactBasic.Html (ReactHtml)
import DTS as DTS
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Data.These (These)
import InteractiveData (DataUI, IDSurface)
import InteractiveData as ID
import InteractiveData.App (AppSelfMsg, AppState)
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.Core (IDOutMsg)
import InteractiveData.Entry (InteractiveDataApp, ToAppCfg, ToAppOptional, ToAppMandatory, defaultToAppCfg)
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import Prim.Boolean (False, True)
import Record as Record
import TS.InteractiveData.Unjustify (unjustify)
import TsBridge (TsRecord, TypeVar)
import TsBridge as TSB
import TsBridge.InteractiveData.Class (Tok(..))
import TsBridge.Types.TsRecord as TsRec
import Type.Proxy (Proxy(..))

------------------------------------------------------------------------------

type ModOpt a = TsRec.Mod (optional :: True, readonly :: True) a

type Mod a = TsRec.Mod (optional :: False, readonly :: True) a

get :: forall @sym r a. TsRec.Get sym r a => TsRecord r -> a
get = TsRec.get (Proxy :: Proxy sym)

------------------------------------------------------------------------------
--- App
------------------------------------------------------------------------------

type TsCfgToApp a =
  TsRecord
    ( fullscreen :: ModOpt Boolean
    , initData :: ModOpt a
    , name :: Mod String
    )

toAppMapCfg :: forall a. TsCfgToApp a -> ToAppCfg a
toAppMapCfg tsCfg =
  let
    cfgOptional :: Record (ToAppOptional a ())
    cfgOptional =
      unjustify
        defaultToAppCfg
        { fullscreen: get @"fullscreen" tsCfg
        , initData: mapInitData $ get @"initData" tsCfg
        }

    mapInitData :: Maybe a -> Maybe (Maybe a)
    mapInitData = Just

    cfgMandatory :: Record (ToAppMandatory ())
    cfgMandatory =
      { name: get @"name" tsCfg
      }
  in
    Record.merge cfgOptional cfgMandatory

toApp
  :: forall @msg @sta @a
   . TsCfgToApp a
  -> DataUI (IDSurface (IDHtmlT ReactHtml)) WrapMsg WrapState msg sta a
  -> InteractiveDataApp
       ReactHtml
       (These (AppSelfMsg (WrapMsg msg)) IDOutMsg)
       (AppState (WrapState sta))
       a
toApp tsOpt =
  let
    cfg :: ToAppCfg a
    cfg = toAppMapCfg tsOpt
  in
    ID.toApp cfg

------------------------------------------------------------------------------
--- TS Bridge
------------------------------------------------------------------------------

moduleName :: String
moduleName = "TS.InteractiveData.Run"

type VarMsg = TypeVar "msg"

type VarSta = TypeVar "sta"

type VarA = TypeVar "a"

type VarB = TypeVar "b"

type VarC = TypeVar "c"

type VarD = TypeVar "d"

tsModules :: Either TSB.AppError (Array DTS.TsModuleFile)
tsModules =
  TSB.tsModuleFile moduleName
    [ TSB.tsValues Tok
        { toApp: toApp @VarMsg @VarSta @VarA
        }
    ]