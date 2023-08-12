module TS.InteractiveData.Variant where

import Prelude

import Chameleon.Impl.ReactBasic (ReactHtml)
import Data.Array as Array
import Data.Maybe (Maybe(..), fromJust)
import Data.Newtype (un)
import Data.Traversable (class Foldable, class Traversable, for)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (type (/\), (/\))
import Data.Variant (Variant)
import DataMVC.Types (DataUI(..), DataUiInterface(..), DataResult)
import DataMVC.Types.DataUI (runDataUiFinal)
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

type Surface = IDSurface (IDHtmlT ReactHtml)

type RDataUI = DataUI Surface WrapMsg WrapState

type VariantMsg rcase rmsg = Variant
  ( childCaseMsg :: Case rcase
  , changeCase :: Case rmsg
  , errorMsg :: String
  )

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

variant_
  :: Key
  -> Obj (RDataUI AnyMsg AnySta AnyA)
  -> RDataUI
       (VariantMsg (Case Unit) (WrapMsg AnyMsg))
       (Case (WrapState AnySta))
       (Case AnyA)
variant_ initKey dataUis = DataUI \ctx ->
  let
    dataUiItfs :: Obj (DataUiInterface Surface (WrapMsg AnyMsg) (WrapState AnySta) AnyA)
    dataUiItfs = map (flip runDataUiFinal ctx) dataUis
  in
    variantItf_ initKey dataUiItfs

variantItf_
  :: forall msg sta a
   . Key
  -> Obj (DataUiInterface Surface msg sta a)
  -> DataUiInterface Surface (VariantMsg (Case Unit) msg) (Case sta) (Case a)
variantItf_ initKey dataUiItfs =
  let
    update :: VariantMsg (Case Unit) msg -> Case sta -> Case sta
    update = unsafeCoerce 1

    extract :: Case sta -> DataResult (Case a)
    extract = unsafeCoerce 1

    init :: Maybe (Case a) -> Case sta
    init = case _ of
      Nothing ->
        let
          itf :: DataUiInterface Surface msg sta a
          itf = lookup initKey dataUiItfs

          init' :: Maybe a -> sta
          init' = itf # un DataUiInterface # _.init
        in
          Case initKey (init' Nothing)

      Just (Case key val) ->
        let
          itf :: DataUiInterface Surface msg sta a
          itf = lookup key dataUiItfs

          init' :: Maybe a -> sta
          init' = itf # un DataUiInterface # _.init

        in
          Case key (init' (Just val))

    view :: Case sta -> Surface (VariantMsg (Case Unit) msg)
    view = unsafeCoerce 1

  in
    DataUiInterface
      { name: "Variant"
      , extract
      , init
      , update
      , view
      }

