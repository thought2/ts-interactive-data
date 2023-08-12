module TS.InteractiveData.Variant
  ( AnyA(..)
  , AnyMsg(..)
  , AnySta(..)
  , Case(..)
  , Key(..)
  , Obj(..)
  , variant_
  ) where

import Prelude

import Chameleon.Impl.ReactBasic (ReactHtml)
import Data.Maybe (Maybe(..), fromJust)
import Data.Newtype (un)
import Data.Traversable (class Foldable, class Traversable)
import Data.Variant (Variant)
import Data.Variant as V
import DataMVC.Types (DataUI(..), DataUiInterface(..), DataResult)
import DataMVC.Types.DataUI (runDataUiFinal)
import Foreign (Foreign)
import Foreign.Object (Object)
import Foreign.Object as Object
import InteractiveData (DataUI, IDSurface)
import InteractiveData.App.WrapData (WrapMsg, WrapState)
import InteractiveData.DataUIs.Variant as Var
import InteractiveData.Run.Types.HtmlT (IDHtmlT)
import MVC.Variant (CaseKey(..))
import Partial.Unsafe (unsafePartial)
import Safe.Coerce (coerce)
import Type.Proxy (Proxy(..))
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
  ( childCaseMsg :: Case rmsg
  , changeCase :: Case rcase
  , errorMsg :: String
  )

lookup :: forall v. Key -> Obj v -> v
lookup (Key key) (Obj obj) =
  unsafePartial $ Object.lookup key obj
    # fromJust

keys :: forall v. Obj v -> Array Key
keys (Obj obj) =
  coerce $ Object.keys obj

variant_
  :: Key
  -> Obj (RDataUI AnyMsg AnySta AnyA)
  -> RDataUI
       (VariantMsg Unit (WrapMsg AnyMsg))
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
  -> DataUiInterface Surface (VariantMsg Unit msg) (Case sta) (Case a)
variantItf_ initKey dataUiItfs =
  let
    update :: VariantMsg Unit msg -> Case sta -> Case sta
    update = V.case_ # V.onMatch
      { childCaseMsg: \(Case keyMsg valSta) (Case keySta valSta') ->
          let
            itf :: DataUiInterface Surface msg sta a
            itf = lookup keyMsg dataUiItfs

            update' :: msg -> sta -> sta
            update' = itf # un DataUiInterface # _.update

            val :: sta
            val = update' valSta valSta'
          in
            Case keySta val

      , changeCase: \(Case keyMsg _) _ ->
          let
            itf :: DataUiInterface Surface msg sta a
            itf = lookup keyMsg dataUiItfs

            init' :: Maybe a -> sta
            init' = itf # un DataUiInterface # _.init

            val :: sta
            val = init' Nothing
          in
            Case keyMsg val
      , errorMsg: unsafeCoerce 3
      }

    extract :: Case sta -> DataResult (Case a)
    extract (Case key val) =
      let
        itf :: DataUiInterface Surface msg sta a
        itf = lookup key dataUiItfs

        extract' :: sta -> DataResult a
        extract' = itf # un DataUiInterface # _.extract

        result :: DataResult a
        result = extract' val
      in
        map (Case key) result

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

    view :: Case sta -> Surface (VariantMsg Unit msg)
    view (Case key@(Key keyStr) val) =
      let
        itf :: DataUiInterface Surface msg sta a
        itf = lookup key dataUiItfs

        view' :: sta -> Surface msg
        view' = itf # un DataUiInterface # _.view

        result :: Surface msg
        result = view' val

        result' :: Surface (VariantMsg Unit msg)
        result' = mapMsg <$> result

        mapMsg :: msg -> VariantMsg Unit msg
        mapMsg = Case key
          >>> V.inj (Proxy :: Proxy "childCaseMsg")

      in
        Var.mkSurface
          { viewCase: result'
          , mkMsg: \(CaseKey keyStr') ->
              V.inj (Proxy :: Proxy "changeCase") (Case (Key keyStr') unit)
          , caseKey: CaseKey keyStr
          , caseKeys: (\(Key keyStr') -> CaseKey keyStr') <$> keys dataUiItfs
          }

  in
    DataUiInterface
      { name: "Variant"
      , extract
      , init
      , update
      , view
      }

