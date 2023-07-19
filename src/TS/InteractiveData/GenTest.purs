module TS.InteractiveData.GenTest where

import Prelude

import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromJust)
import Data.Newtype (un)
import Data.Traversable (class Foldable, class Traversable, for)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (type (/\), (/\))
import Foreign (Foreign)
import Foreign.Object (Object)
import Foreign.Object as Obj
import Foreign.Object as Object
import InteractiveData (IDSurface, WrapMsg, WrapState)
import InteractiveData.Core.Types (DataUI(..), IDError, DataUiItf(..), runDataUi)
import InteractiveData.DataUI.Record as R
import InteractiveData.Impl (IDHtmlT)
import MVC.Record (ViewResult)
import Partial.Unsafe (unsafePartial)
import Safe.Coerce (coerce)
import VirtualDOM.Impl.ReactBasic (ReactHtml)

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

dataUiRecord_
  :: Obj (RDataUI AnyMsg AnySta AnyA)
  -> RDataUI (Case AnyMsg) (Obj AnySta) (Obj AnyA)
dataUiRecord_ dataUis = DataUI \ctx -> DataUiItf
  let
    dataUiItfs :: Obj (DataUiItf Surface AnyMsg AnySta AnyA)
    dataUiItfs = map (flip runDataUi ctx) dataUis

    update :: Case AnyMsg -> Obj AnySta -> Obj AnySta
    update (Case key val) states =
      let
        itf :: DataUiItf Surface AnyMsg AnySta AnyA
        itf = lookup key dataUiItfs

        update' :: AnyMsg -> AnySta -> AnySta
        update' = itf # un DataUiItf # _.update
      in
        modify (update' val) key states

    extract :: Obj AnySta -> Either IDError (Obj AnyA)
    extract states =
      for (zip Tuple states dataUiItfs) \(state /\ itf) -> do

        let
          extract' :: AnySta -> Either IDError AnyA
          extract' = itf # un DataUiItf # _.extract

        value :: AnyA <- extract' state
        pure value

    init :: Either IDError (Obj AnyA) -> Obj AnySta
    init = case _ of
      Left err ->
        dataUiItfs # map \itf ->
          let
            init' :: Either IDError AnyA -> AnySta
            init' = itf # un DataUiItf # _.init
          in
            init' (Left err)

      Right vals -> zip
        ( \val itf ->
            let
              init' :: Either IDError AnyA -> AnySta
              init' = itf # un DataUiItf # _.init
            in
              init' (Right val)
        )
        vals
        dataUiItfs

    view :: Obj AnySta -> Surface (Case AnyMsg)
    view states =
      let
        surfaces :: Obj (Surface AnyMsg)
        surfaces = zip
          ( \state itf ->
              let
                view' :: AnySta -> Surface AnyMsg
                view' = itf # un DataUiItf # _.view
              in
                view' state
          )
          states
          dataUiItfs

        surfacesIter :: Array (Key /\ Surface AnyMsg)
        surfacesIter = toIter surfaces

        viewResults :: Array (ViewResult Surface (Case AnyMsg))
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
    { name: "Record"
    , extract
    , init
    , update
    , view
    }
