module Mousikea.Examples.Drums exposing (africanDrumBeat, simpleBeat)

import Mousikea.Music exposing (..)
import Mousikea.Types
    exposing
        ( InstrumentName(..)
        , Music(..)
        , Music1
        , NoteAttribute(..)
        , Primitive(..)
        )
import Mousikea.Types.PercussionSound exposing (PercussionSound(..))
import Mousikea.Util.Ratio as Ratio


simpleBeat : Music1
simpleBeat =
    times 2 (perc AcousticBassDrum hn)
        |> Par (times 8 (perc ClosedHiHat en))
        |> Par (line [ rest qn, perc AcousticSnare qn ] |> times 2)
        |> times 16
        |> mMap (\p -> ( p, [ Volume 60 ] ))


africanDrumBeat : Music1
africanDrumBeat =
    line [ perc RideBell qn, perc RideBell qn, perc RideBell qn, rest en, perc RideBell qn, perc RideBell qn, rest en ]
        |> Par (times 4 (perc AcousticBassDrum dqn))
        |> Par (times 6 (perc PedalHiHat qn))
        |> Par (line [ rest qn, perc SideStick en, rest en, perc HighTom en |> times 2, rest qn, perc SideStick en, rest en, perc LowTom en |> times 2 ])
        |> times 16
        |> tempo (Ratio.mul (Ratio.div dqn qn) (Ratio.over 120 120))
        |> mMap (\p -> ( p, [ Volume 60 ] ))
