module TS.InteractiveData
  ( runReactHtml
  , string_
  , toApp
  , tsModules
  , useApp
  ) where

import Prelude

import Chameleon (Key(..))
import Chameleon.Impl.ReactBasic (ReactHtml)
import Chameleon.Impl.ReactBasic as C.R
import DTS as DTS
import Data.Either (Either)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Data.These (These)
import Data.Tuple (Tuple)
import DataMVC.Types (DataResult)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Foreign (Foreign)
import InteractiveData (DataUI, IDSurface, StringMsg, StringState)
import InteractiveData as ID
import InteractiveData.App (AppSelfMsg, AppState)
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.Core (IDOutMsg)
import InteractiveData.DataUIs.String (CfgString)
import InteractiveData.DataUIs.String as DataUIs.String
import InteractiveData.Entry (InteractiveDataApp, ToAppCfg, ToAppOptional, ToAppMandatory, defaultToAppCfg)
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import Literals.Null as Lit
import Prim.Boolean (False, True)
import React.Basic (JSX)
import Record as Record
import TS.InteractiveData.Unjustify (unjustify)
import TsBridge (TsRecord, TypeVar)
import TsBridge as TSB
import TsBridge.InteractiveData.Class (Tok(..))
import TsBridge.Types.TsRecord as TsRec
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (type (|+|), fromOneOf)

------------------------------------------------------------------------------

type ModOpt a = TsRec.Mod (optional :: True, readonly :: True) a

type Mod a = TsRec.Mod (optional :: False, readonly :: True) a

get :: forall @sym r a. TsRec.Get sym r a => TsRecord r -> a
get = TsRec.get (Proxy :: Proxy sym)

------------------------------------------------------------------------------
--- String
------------------------------------------------------------------------------

type TsCfgString =
  TsRecord
    ( multilineInline :: ModOpt Boolean
    , multilineStandalone :: ModOpt Boolean
    , maxLength :: ModOpt (Number |+| Lit.Null)
    )

stringMapCfg :: TsCfgString -> CfgString StringMsg
stringMapCfg tsOpt =
  unjustify
    DataUIs.String.defaultCfgString
    { multilineInline: get @"multilineInline" tsOpt
    , multilineStandalone: get @"multilineStandalone" tsOpt
    , actions: Nothing
    , maxLength: map mapMaxLength $ get @"maxLength" tsOpt
    }
  where

  mapMaxLength :: Number |+| Lit.Null -> Maybe Int
  mapMaxLength val =
    let
      maybeNumber :: Maybe Number
      maybeNumber = fromOneOf val
    in
      map Int.round maybeNumber

string_
  :: TsCfgString
  -> DataUI (IDSurface (IDHtmlT ReactHtml)) WrapMsg WrapState StringMsg StringState String
string_ opt =
  let
    cfg :: CfgString StringMsg
    cfg = stringMapCfg opt
  in
    ID.string cfg

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
--- Run
------------------------------------------------------------------------------

runReactHtml
  :: forall @a
   . { handler :: a -> Effect Unit }
  -> ReactHtml a
  -> JSX
runReactHtml h = C.R.runReactHtml h C.R.defaultConfig

------------------------------------------------------------------------------
--- Hooks
------------------------------------------------------------------------------

foreign import useState
  :: forall a
   . a
  -> { state :: a, setState :: EffectFn1 (a -> a) Unit }

useApp
  :: forall @msg @sta @a
   . InteractiveDataApp ReactHtml msg sta a
  -> { jsx :: JSX, data :: DataResult a }
useApp { ui, extract } =
  let
    { state, setState } = useState ui.init

    reactHtml :: ReactHtml msg
    reactHtml = ui.view state

    handler :: msg -> Effect Unit
    handler msg = runEffectFn1 setState (ui.update msg)

    jsx :: JSX
    jsx = runReactHtml { handler } reactHtml

    dataResult :: DataResult a
    dataResult = extract state
  in
    { jsx, data: dataResult }

------------------------------------------------------------------------------
--- TS Bridge
------------------------------------------------------------------------------

moduleName :: String
moduleName = "TS.InteractiveData"

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
        { string_
        , toApp: toApp @VarMsg @VarSta @VarA
        , runReactHtml: runReactHtml @VarA
        , useApp: useApp @VarMsg @VarSta @VarA
        }
    ]