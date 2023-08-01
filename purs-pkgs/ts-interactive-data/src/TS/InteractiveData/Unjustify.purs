module TS.InteractiveData.Unjustify where


import Data.Maybe (Maybe, fromMaybe)
import Data.Symbol (class IsSymbol)
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record as Record
import Type.Proxy (Proxy(..))

--------------------------------------------------------------------------------
--- Unjustify
--------------------------------------------------------------------------------

class
  Unjustify all maybes
  | all -> maybes
  where
  unjustify :: all -> maybes -> all

instance
  ( RowToList all rl
  , UnjustifyRL rl (Record all) (Record maybes) (Record all)
  ) =>
  Unjustify (Record all) (Record maybes)
  where
  unjustify :: Record all -> Record maybes -> Record all
  unjustify =
    unjustifyRL prxRl
    where
    prxRl :: Proxy rl
    prxRl = Proxy

---

t1
  :: { field1 :: Int, field2 :: String, field3 :: Boolean }
  -> { field1 :: Maybe Int, field2 :: Maybe String, field3 :: Maybe Boolean }
  -> { field1 :: Int, field2 :: String, field3 :: Boolean }
t1 = unjustify

--------------------------------------------------------------------------------
--- UnjustifyRL
--------------------------------------------------------------------------------

class
  UnjustifyRL (rl :: RowList Type) defaults maybes all
  | rl defaults maybes -> all
  where
  unjustifyRL :: Proxy rl -> defaults -> maybes -> all

instance UnjustifyRL RL.Nil defaults maybes (Record ())
  where
  unjustifyRL :: Proxy RL.Nil -> defaults -> maybes -> Record ()
  unjustifyRL _ _ _ = {}

instance
  ( UnjustifyRL rlPrev (Record defaults) (Record maybes) (Record allPrev)
  , Row.Cons sym a defaultsTrash defaults
  , Row.Cons sym a allPrev all
  , Row.Cons sym (Maybe a) maybesTrash maybes
  , IsSymbol sym
  , Row.Lacks sym allPrev
  ) =>
  UnjustifyRL (RL.Cons sym a rlPrev) (Record defaults) (Record maybes) (Record all)
  where
  unjustifyRL :: Proxy (RL.Cons sym a rlPrev) -> Record defaults -> Record maybes -> Record all
  unjustifyRL Proxy defaults maybes =
    let
      prxRlPrev :: Proxy rlPrev
      prxRlPrev = Proxy

      prxSym :: Proxy sym
      prxSym = Proxy

      tail :: Record allPrev
      tail = unjustifyRL prxRlPrev defaults maybes

      default :: a
      default = Record.get prxSym defaults

      maybeVal :: Maybe a
      maybeVal = Record.get prxSym maybes

      val :: a
      val = fromMaybe default maybeVal
    in
      Record.insert prxSym val tail
