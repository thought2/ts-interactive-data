module TS.InteractiveData.ReactHtml where

import Prelude

import InteractiveData (IDOutMsg, ViewCtx)
import InteractiveData.Types (class IDHtml)
import Unsafe.Coerce (unsafeCoerce)
import VirtualDOM (class Html)
import VirtualDOM.Impl.ReactBasic as R
import VirtualDOM.Styled (class RegisterStyleMap)
import VirtualDOM.Transformers.Ctx.Class (class AskCtx, class Ctx)
import VirtualDOM.Transformers.OutMsg.Class (class OutMsg, class RunOutMsg)


-- newtype ReactHtml msg = ReactHtml (R.ReactHtml msg)

-- instance IDHtml ReactHtml

-- instance Html ReactHtml where
--   elem = unsafeCoerce \_ -> 1
--   elemKeyed = unsafeCoerce \_ -> 1
--   text = unsafeCoerce \_ -> 1

-- instance Ctx ViewCtx ReactHtml where
--   setCtx = unsafeCoerce \_ -> 1

-- instance AskCtx ViewCtx ReactHtml where
--   withCtx = unsafeCoerce \_ -> 1

-- instance OutMsg IDOutMsg ReactHtml where
--   fromOutHtml = unsafeCoerce \_ -> 1

-- instance RunOutMsg IDOutMsg ReactHtml where
--   runOutMsg = unsafeCoerce \_ -> 1

-- instance RegisterStyleMap ReactHtml where
--   registerStyleMap = unsafeCoerce \_ -> 1

-- derive instance Functor ReactHtml
