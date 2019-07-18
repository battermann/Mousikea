module Mousikea.Examples.BlueLambda exposing (blueLambda)

import Mousikea.Music exposing (..)
import Mousikea.Types
    exposing
        ( InstrumentName(..)
        , Music(..)
        , Music1
        , NoteAttribute(..)
        )
import Mousikea.Util.Ratio as Ratio


blueLambda : Music1
blueLambda =
    let
        x1 =
            line [ c 4 en, g 4 en, c 5 en, g 5 en ]

        x2 =
            Seq x1 (transpose 3 x1)

        x3 =
            line [ x2, x2, invert x2, retro x2 ]

        x4 =
            Par (times 6 x3) (times 4 <| tempo (Ratio.over 2 3) x3)
    in
    x4
        |> instrument RhodesPiano
        |> mMap (\p -> ( p, [ Volume 60 ] ))
