module TS.InteractiveData.React
  ( mkIdHtml
  , runReactHtml
  , tsModules
  , useApp
  ) where

import Prelude

import Chameleon.Impl.ReactBasic as C.R
import Chameleon.Impl.ReactBasic.Html (ReactHtml(..))
import Chameleon.Transformers.Ctx.Trans (CtxT(..))
import Chameleon.Transformers.FunctorTrans.Class as FT
import Chameleon.Transformers.OutMsg.Trans (OutMsgT(..))
import DTS as DTS
import Data.Either (Either)
import Data.These (These(..))
import DataMVC.Types (DataResult)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import InteractiveData.Core (IDOutMsg, IDViewCtx)
import InteractiveData.Entry (InteractiveDataApp)
import InteractiveData.Run.Types.HtmlT (IDHtmlT(..))
import React.Basic (JSX)
import TsBridge (TypeVar)
import TsBridge as TSB
import TsBridge.InteractiveData.Class (Tok(..))

------------------------------------------------------------------------------
--- Run
------------------------------------------------------------------------------

runReactHtml
  :: forall @a
   . { handler :: a -> Effect Unit }
  -> ReactHtml a
  -> JSX
runReactHtml h = C.R.runReactHtml h C.R.defaultConfig

mkIdHtml
  :: forall @msg
   . ( { onMsg :: msg -> Effect Unit
       , onGlobalMsg :: IDOutMsg -> Effect Unit
       , ctx :: IDViewCtx
       }
       -> JSX
     )
  -> IDHtmlT ReactHtml msg
mkIdHtml mkJsx = IDHtmlT $
  CtxT \ctx ->
    let
      html :: ReactHtml (These msg IDOutMsg)
      html = ReactHtml \{ handler } _ -> mkJsx
        { onMsg: handler <<< This
        , onGlobalMsg: handler <<< That
        , ctx
        }
    in
      FT.lift $ OutMsgT html

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
moduleName = "TS.InteractiveData.React"

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
        { runReactHtml: runReactHtml @VarA
        , useApp: useApp @VarMsg @VarSta @VarA

        , mkIdHtml: mkIdHtml @VarMsg

        }
    ]