module TsBridge.InteractiveData.Main where

import Prelude

import Effect (Effect)
import TsBridge.InteractiveData.Modules (tsProgram)
import TsBridge as TsBridge

main :: Effect Unit
main = TsBridge.mkTypeGenCli tsProgram