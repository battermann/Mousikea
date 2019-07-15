module Mousikea.Examples.Drums exposing (simpleBeat)

import Mousikea.Music exposing (..)
import Mousikea.Types exposing (..)
import Mousikea.Types.PercussionSound exposing (..)


simpleBeat : Music Pitch
simpleBeat =
    times 2 (perc AcousticBassDrum hn)
        |> Par (times 8 (perc ClosedHiHat en))
        |> Par (line [ rest qn, perc AcousticSnare qn ] |> times 2)
        |> times 16


africanDrumBeat : Music Pitch
africanDrumBeat =
    empty
