module Mousikea.Examples.SingASongOfSong exposing (song)

import Mousikea.Music exposing (..)
import Mousikea.Types
    exposing
        ( Dur
        , InstrumentName(..)
        , Music(..)
        , Pitch
        , Primitive(..)
        )
import Mousikea.Types.PercussionSound exposing (PercussionSound(..))
import Mousikea.Util.Ratio as Ratio


drums : Music Pitch
drums =
    [ qn, qn, en, qn, qn, en, qn, en, qn, en ]
        |> List.map (perc RideCymbal1)
        |> line
        |> Par ([ dqn, dqn, qn ] |> List.map (perc BassDrum1) |> line)
        |> Par (Seq (line [ rest qn, perc SideStick dhn ]) (line [ perc SideStick dqn, perc HighTom dqn, perc LowTom qn ]))
        |> Par (times 4 (perc PedalHiHat qn))


bass1 : Music Pitch
bass1 =
    line [ e_ 2 dqn, b 2 dqn, gs 3 (Ratio.add qn wn) ]


bass2 : Music Pitch
bass2 =
    line [ e_ 2 dqn, b 2 dqn, e_ 3 (Ratio.add qn wn) ]


bass : Music Pitch
bass =
    line [ bass1, transpose -4 bass1, transpose -2 bass1, bass2 ]
        |> instrument AcousticBass


melody : Music Pitch
melody =
    line
        [ line [ gs 4 qn, fs 4 en, gs 4 en, a 4 qn, gs 4 en, fs 4 en ]
        , line [ rest en, e_ 4 dqn, b 3 en, d 4 en, e_ 4 (Ratio.add qn bn) ]
        , line [ fs 4 qn, e_ 4 en, fs 4 en, g 4 qn, fs 4 en, e_ 4 en ]
        , line [ rest en, d 4 dqn, b 3 en, d 4 en, e_ 4 (Ratio.add qn bn) ]
        ]
        |> instrument RhodesPiano


rythm : Music Pitch
rythm =
    times 4 drums
        |> Par bass


song : Music Pitch
song =
    Seq rythm (Par rythm melody |> times 3)
        |> times 2
        |> tempo (Ratio.mul (Ratio.div qn qn) (Ratio.over 200 120))
