module TS.InteractiveData.DataUIs
  ( number
  , string
  , tsModules
  ) where

import Prelude

import Chameleon.Impl.ReactBasic.Html (ReactHtml)
import Control.Bind (bindFlipped)
import DTS as DTS
import Data.Either (Either)
import Data.Int as Int
import Data.Maybe (Maybe(..))
import InteractiveData
  ( DataUI
  , IDSurface
  , NumberMsg
  , NumberState
  , StringMsg
  , StringState
  , WrapMsg
  , WrapState
  , IDHtmlT
  )
import InteractiveData as ID
import InteractiveData.DataUIs.Number (CfgNumber)
import InteractiveData.DataUIs.Number as DataUIs.Number
import InteractiveData.DataUIs.String (CfgString)
import InteractiveData.DataUIs.String as DataUIs.String
import Literals.Null as Lit
import Prim.Boolean (False, True)
import TS.InteractiveData.Unjustify (unjustify)
import TsBridge (TsRecord, TypeVar)
import TsBridge as TSB
import TsBridge.InteractiveData.Class (Tok(..))
import TsBridge.Types.TsRecord as TsRec
import Type.Proxy (Proxy(..))
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
    ( text :: ModOpt String
    , multiline :: ModOpt Boolean
    , rows :: ModOpt (Number |+| Lit.Null)
    , maxLength :: ModOpt (Number |+| Lit.Null)
    )

stringMapCfg :: TsCfgString -> CfgString StringMsg
stringMapCfg tsOpt =
  unjustify
    DataUIs.String.defaultCfgString
    { text: Just $ get @"text" tsOpt
    , multiline: get @"multiline" tsOpt
    , rows: bindFlipped mapInt $ get @"rows" tsOpt
    , actions: Nothing
    , maxLength: map mapInt $ get @"maxLength" tsOpt
    }
  where

  mapInt :: Number |+| Lit.Null -> Maybe Int
  mapInt val =
    let
      maybeNumber :: Maybe Number
      maybeNumber = fromOneOf val
    in
      map Int.round maybeNumber

string
  :: TsCfgString
  -> DataUI (IDSurface (IDHtmlT ReactHtml)) WrapMsg WrapState StringMsg StringState String
string opt =
  let
    cfg :: CfgString StringMsg
    cfg = stringMapCfg opt
  in
    ID.string cfg

------------------------------------------------------------------------------
--- Number
------------------------------------------------------------------------------

type TsCfgNumber =
  TsRecord
    ( min :: ModOpt Number
    , max :: ModOpt Number
    , step :: ModOpt Number
    , text :: ModOpt String
    , init :: ModOpt Number
    )

intMapCfg :: TsCfgNumber -> CfgNumber
intMapCfg tsOpt =
  unjustify
    DataUIs.Number.defaultCfgNumber
    { min: get @"min" tsOpt
    , max: get @"max" tsOpt
    , step: get @"step" tsOpt
    , text: Just $ get @"text" tsOpt
    , init: Just $ get @"init" tsOpt
    }

number
  :: TsCfgNumber
  -> DataUI (IDSurface (IDHtmlT ReactHtml)) WrapMsg WrapState NumberMsg NumberState Number
number opt =
  let
    cfg :: CfgNumber
    cfg = intMapCfg opt
  in
    ID.number cfg

------------------------------------------------------------------------------
--- TS Bridge
------------------------------------------------------------------------------

moduleName :: String
moduleName = "TS.InteractiveData.DataUIs"

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
        { string
        , number
        }
    ]