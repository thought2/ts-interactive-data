module TS.InteractiveData.DataUtil
  ( matchEither
  , matchMaybe
  , mkJust
  , mkLeft
  , mkNothing
  , mkRight
  , noTreeChildren
  , tsModules
  ) where

import Prelude

import Chameleon.Impl.ReactBasic (ReactHtml)
import DTS as DTS
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import InteractiveData.Core (DataTreeChildren(..))
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import TsBridge (TypeVar)
import TsBridge as TSB
import TsBridge.InteractiveData.Class (Tok(..))

--------------------------------------------------------------------------------
--- Either
--------------------------------------------------------------------------------

mkLeft :: forall @a @b. a -> Either a b
mkLeft x = Left x

mkRight :: forall @a @b. b -> Either a b
mkRight x = Right x

matchEither
  :: forall @a @b @c
   . { onLeft :: a -> c, onRight :: b -> c }
  -> Either a b
  -> c
matchEither { onLeft, onRight } =
  case _ of
    Left x -> onLeft x
    Right x -> onRight x

--------------------------------------------------------------------------------
--- Maybe
--------------------------------------------------------------------------------

mkJust :: forall @a. a -> Maybe a
mkJust x = Just x

mkNothing :: forall @a. Unit -> Maybe a
mkNothing _ = Nothing

matchMaybe :: forall @a @b. { onJust :: a -> b, onNothing :: Unit -> b } -> Maybe a -> b
matchMaybe { onJust, onNothing } =
  case _ of
    Just x -> onJust x
    Nothing -> onNothing unit

------------------------------------------------------------------------------
--- Custom Data UI Utils
------------------------------------------------------------------------------

noTreeChildren :: forall @msg. Unit -> DataTreeChildren (IDHtmlT ReactHtml) msg
noTreeChildren _ = Fields []

------------------------------------------------------------------------------
--- TS Bridge
------------------------------------------------------------------------------

moduleName :: String
moduleName = "TS.InteractiveData.DataUtil"

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
        { mkLeft: mkLeft @VarA @VarB
        , mkRight: mkRight @VarA @VarB
        , matchEither: matchEither @VarA @VarB @VarC

        , mkJust: mkJust @VarA
        , mkNothing: mkNothing @VarA
        , matchMaybe: matchMaybe @VarA @VarB

        , noTreeChildren: noTreeChildren @VarMsg
        }
    ]