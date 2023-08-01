module TS.InteractiveData
  ( dataUi
  , string_
  , tsModules
  ) where

import Prelude

import Chameleon.Impl.ReactBasic (ReactHtml)
import DTS as DTS
import Data.Either (Either)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import InteractiveData (DataUI, IDSurface, StringMsg, StringState)
import InteractiveData as ID
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.DataUIs.String (CfgString)
import InteractiveData.DataUIs.String as DataUIs.String
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import Literals.Null as Lit
import Prim.Boolean (True)
import TS.InteractiveData.Unjustify (unjustify)
import TsBridge (TsRecord, TypeVar)
import TsBridge as TSB
import TsBridge.InteractiveData.Class (Tok(..))
import TsBridge.Types.TsRecord as TsRec
import Type.Proxy (Proxy(..))
import Untagged.Union (type (|+|), fromOneOf)

------------------------------------------------------------------------------

type Mod a = TsRec.Mod (optional :: True, readonly :: True) a

get :: forall @sym r a. TsRec.Get sym r a => TsRecord r -> a
get = TsRec.get (Proxy :: Proxy sym)

------------------------------------------------------------------------------

type TsCfgString =
  TsRecord
    ( multilineInline :: Mod Boolean
    , multilineStandalone :: Mod Boolean
    , maxLength :: Mod (Number |+| Lit.Null)
    )

string_
  :: TsCfgString
  -> DataUI (IDSurface (IDHtmlT ReactHtml)) WrapMsg WrapState StringMsg StringState String
string_ opt =
  let
    cfg :: CfgString StringMsg
    cfg =
      unjustify
        DataUIs.String.defaultCfgString
        { multilineInline: get @"multilineInline" opt
        , multilineStandalone: get @"multilineStandalone" opt
        , actions: Nothing
        , maxLength: map mapMaxLength $ get @"maxLength" opt
        }

    mapMaxLength :: Number |+| Lit.Null -> Maybe Int
    mapMaxLength val =
      let
        maybeNumber :: Maybe Number
        maybeNumber = fromOneOf val
      in
        map Int.round maybeNumber

  in
    ID.string cfg

------------------------------------------------------------------------------
--- TS Bridge
------------------------------------------------------------------------------

moduleName :: String
moduleName = "TS.InteractiveData"

type VarMsg = TypeVar "msg"
type VarSta = TypeVar "sta"
type VarA = TypeVar "a"
type VarB = TypeVar "b"

tsModules :: Either TSB.AppError (Array DTS.TsModuleFile)
tsModules =
  TSB.tsModuleFile moduleName
    [ TSB.tsValues Tok
        { dataUi
        , string_
        }
    ]