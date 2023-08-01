module TsBridge.InteractiveData.Class where

import Prelude

import DTS as DTS

import TsBridge (TypeVar)
import TsBridge as TSB
import Type.Proxy (Proxy)

class TsBridge (a :: Type) where
  tsBridge :: Proxy a -> TSB.TsBridgeM DTS.TsType

data Tok = Tok

instance TsBridge a => TSB.TsBridgeBy Tok a where
  tsBridgeBy _ = tsBridge
