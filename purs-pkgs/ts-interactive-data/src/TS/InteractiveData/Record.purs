module TS.InteractiveData.Record
  ( AnyA(..)
  , AnyMsg(..)
  , AnySta(..)
  , Case(..)
  , Key(..)
  , Obj(..)
  , record_
  ) where

import Prelude

import Chameleon.Impl.ReactBasic (ReactHtml)
import Data.Array as Array
import Data.Maybe (Maybe(..), fromJust)
import Data.Newtype (un)
import Data.Traversable (class Foldable, class Traversable, for)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (type (/\), (/\))
import DataMVC.Types (DataUI(..), DataUiInterface(..), DataResult)
import DataMVC.Types.DataUI (runDataUi, runDataUiFinal)
import Foreign (Foreign)
import Foreign.Object (Object)
import Foreign.Object as Obj
import Foreign.Object as Object
import InteractiveData (DataUI, IDSurface)
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.DataUIs.Record as R
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import MVC.Record (ViewResult)
import Partial.Unsafe (unsafePartial)
import Safe.Coerce (coerce)
import Unsafe.Coerce (unsafeCoerce)

newtype Key = Key String

data Case a = Case Key a

newtype AnyMsg = AnyMsg Foreign
newtype AnySta = AnySta Foreign
newtype AnyA = AnyA Foreign

newtype Obj v = Obj (Object v)

derive instance Functor Obj

derive newtype instance Traversable Obj

derive newtype instance Foldable Obj

lookup :: forall v. Key -> Obj v -> v
lookup (Key key) (Obj obj) =
  unsafePartial $ Object.lookup key obj
    # fromJust

modify :: forall v. (v -> v) -> Key -> Obj v -> Obj v
modify f (Key key) (Obj obj) =
  Obj $ Object.update (f >>> Just) key obj

toIter :: forall v. Obj v -> Array (Key /\ v)
toIter (Obj obj) =
  coerce $ (Obj.toUnfoldable obj :: Array _)

zip :: forall v1 v2 v3. (v1 -> v2 -> v3) -> Obj v1 -> Obj v2 -> Obj v3
zip f (Obj obj1) (Obj obj2) =
  let
    obj1Iter :: Array (Key /\ v1)
    obj1Iter = coerce (Obj.toUnfoldable obj1 :: Array _)

    obj2Iter :: Array (Key /\ v2)
    obj2Iter = coerce (Obj.toUnfoldable obj2 :: Array _)

    obj3Iter :: Array (Key /\ v3)
    obj3Iter = Array.zipWith
      (\(key /\ v1) (_ /\ v2) -> key /\ f v1 v2)
      obj1Iter
      obj2Iter

    obj3Iter' :: Array (String /\ v3)
    obj3Iter' = coerce obj3Iter
  in
    Obj $ Obj.fromFoldable obj3Iter'

type Surface = IDSurface (IDHtmlT ReactHtml)

type RDataUI = DataUI Surface WrapMsg WrapState

record_
  :: Obj (RDataUI AnyMsg AnySta AnyA)
  -> RDataUI (Case (WrapMsg AnyMsg)) (Obj (WrapState AnySta)) (Obj AnyA)
record_ dataUis = DataUI \ctx ->
  let
    dataUiItfs :: Obj (DataUiInterface Surface (WrapMsg AnyMsg) (WrapState AnySta) AnyA)
    dataUiItfs = map (flip runDataUiFinal ctx) dataUis
  in
    recordItf_ dataUiItfs

recordItf_
  :: forall msg sta a
   . Obj (DataUiInterface Surface msg sta a)
  -> DataUiInterface Surface (Case msg) (Obj sta) (Obj a)
recordItf_ dataUiItfs =
  let

    update :: Case msg -> Obj sta -> Obj sta
    update (Case key val) states =
      let
        itf :: DataUiInterface Surface msg sta a
        itf = lookup key dataUiItfs

        update' :: msg -> sta -> sta
        update' = itf # un DataUiInterface # _.update
      in
        modify (update' val) key states

    extract :: Obj sta -> DataResult (Obj a)
    extract states =
      for (zip Tuple states dataUiItfs) \(state /\ itf) -> do

        let
          extract' :: sta -> DataResult a
          extract' = itf # un DataUiInterface # _.extract

        value :: a <- extract' state
        pure value

    init :: Maybe (Obj a) -> Obj sta
    init = case _ of
      Nothing ->
        dataUiItfs # map \itf ->
          let
            init' :: Maybe a -> sta
            init' = itf # un DataUiInterface # _.init
          in
            init' Nothing

      Just vals -> zip
        ( \val itf ->
            let
              init' :: Maybe a -> sta
              init' = itf # un DataUiInterface # _.init
            in
              init' (Just val)
        )
        vals
        dataUiItfs

    view :: Obj sta -> Surface (Case msg)
    view states =
      let
        surfaces :: Obj (Surface msg)
        surfaces = zip
          ( \state itf ->
              let
                view' :: sta -> Surface msg
                view' = itf # un DataUiInterface # _.view
              in
                view' state
          )
          states
          dataUiItfs

        surfacesIter :: Array (Key /\ Surface msg)
        surfacesIter = toIter surfaces

        viewResults :: Array (ViewResult Surface (Case msg))
        viewResults = surfacesIter # map
          \(key@(Key keyStr) /\ surface) ->
            { key: keyStr
            , viewValue: map (Case key) surface
            }
      in
        R.mkSurface
          { mkSegment: R.mkSegmentStatic }
          viewResults

  in
    DataUiInterface
      { name: "Record"
      , extract
      , init
      , update
      , view
      }
