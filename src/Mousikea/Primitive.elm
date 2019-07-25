module Mousikea.Primitive exposing
    ( Dur
    , Primitive(..)
    , map
    )

import Mousikea.Util.Ratio exposing (Rational)


type alias Dur =
    Rational


type Primitive a
    = Note Dur a
    | Rest Dur


map : (a -> b) -> Primitive a -> Primitive b
map func prim =
    case prim of
        Note dur x ->
            Note dur (func x)

        Rest dur ->
            Rest dur
