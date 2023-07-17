module TS.InteractiveData.TsBridge.Main where

import Prelude

import Effect (Effect)
import TS.InteractiveData.TsBridge.Modules (myTsProgram)
import TsBridge as TsBridge

main :: Effect Unit
main = TsBridge.mkTypeGenCli myTsProgram