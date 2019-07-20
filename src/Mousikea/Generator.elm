module Mousikea.Generator exposing (bossa, example)

import List.Extra
import Mousikea.Music exposing (..)
import Mousikea.Types
    exposing
        ( AbsPitch
        , Dur
        , InstrumentName(..)
        , Music(..)
        , Music1
        , NoteAttribute(..)
        , Pitch
        , Primitive(..)
        , Volume
        )
import Mousikea.Util.Ratio as Ratio
import Random


type alias Scale =
    List AbsPitch


type alias MusicV =
    Music ( AbsPitch, Volume )


bossa : Random.Generator MusicV
bossa =
    let
        cMin =
            [ 0, 2, 3, 5, 7, 8, 10 ]

        cMaj =
            [ 0, 2, 4, 5, 7, 9, 11 ]

        minAndMajScales =
            List.range 0 11 |> List.Extra.andThen (\root -> [ cMin |> List.map ((+) root), cMaj |> List.map ((+) root) ])

        durScalePairs n =
            Random.list n (Random.uniform cMin (List.tail minAndMajScales |> Maybe.withDefault []))
                |> Random.map (List.map (Tuple.pair (Ratio.fromInt 2)))
    in
    durScalePairs 32
        |> Random.andThen mkBossa
        |> Random.map (tempo (Ratio.over 3 2))


mkBossa : List ( Dur, Scale ) -> Random.Generator MusicV
mkBossa durScalesPairs =
    case durScalesPairs of
        [] ->
            Random.constant empty

        ( dur, scale ) :: tail ->
            let
                transScale =
                    List.map ((+) 60) scale

                mkBass root fifth =
                    line
                        [ note dqn ( 36 + root, 100 )
                        , note en ( 36 + root, 80 )
                        , note dqn ( 36 + fifth, 100 )
                        , note en ( 36 + fifth, 80 )
                        ]
                        |> times 8
                        |> cut dur
                        |> instrument AcousticBass

                mkComp third seventh =
                    line
                        [ chord [ note en (third + 48), note en (seventh + 48) ]
                        , rest en
                        , chord [ note en (third + 48), note en (seventh + 48) ]
                        , rest qn
                        , chord [ note en (third + 48), note en (seventh + 48) ]
                        , rest en
                        , chord [ note en (third + 48), note en (seventh + 48) ]
                        , rest en
                        , chord [ note en (third + 48), note en (seventh + 48) ]
                        , rest qn
                        , chord [ note en (third + 48), note en (seventh + 48) ]
                        , rest en
                        , chord [ note en (third + 48), note en (seventh + 48) ]
                        , rest en
                        ]
                        |> mMap (\p -> ( p, 60 ))
                        |> cut dur
                        |> instrument RhodesPiano

                bass =
                    Maybe.map2 mkBass (List.Extra.getAt 0 scale) (List.Extra.getAt 4 scale)

                comp =
                    Maybe.map2 mkComp (List.Extra.getAt 0 scale) (List.Extra.getAt 4 scale)

                rythm =
                    Maybe.map2 Par bass comp
                        |> Maybe.withDefault empty

                mel =
                    randomMel dur transScale [ qn, en, en, en ] 40
                        |> Random.map (instrument Vibraphone)

                rythmAndMel =
                    mel |> Random.map (Par rythm)
            in
            Random.map2 Seq rythmAndMel (mkBossa tail)


example : Random.Generator MusicV
example =
    let
        mel1 =
            randomMel (Ratio.fromInt 32) [ 60, 62, 63, 65, 67, 68, 70, 72, 73, 75, 77, 79 ] [ qn, en, en, en ] 60
                |> Random.map (instrument Vibraphone)

        mel2 =
            randomMel (Ratio.fromInt 32) [ 36, 36, 43, 43, 46, 48 ] [ hn, qn, qn, qn ] 20
                |> Random.map (instrument AcousticBass)
    in
    Random.map2 Par mel1 mel2
        |> Random.map (tempo (Ratio.fromInt 2))


randomMel : Dur -> List AbsPitch -> List Dur -> Int -> Random.Generator MusicV
randomMel dur pitches durs thres =
    let
        rndMel acc =
            if Ratio.gt (duration acc) dur then
                Random.constant (cut dur acc)

            else
                randomPrim pitches durs thres
                    |> Random.andThen (\m -> rndMel (Seq m acc))
    in
    rndMel empty


randomPrim : List AbsPitch -> List Dur -> Int -> Random.Generator MusicV
randomPrim pitches durs thres =
    case ( pitches, durs ) of
        ( p :: ps, d :: ds ) ->
            let
                mkPrim ap dur vol =
                    if vol < thres then
                        rest dur

                    else
                        note dur ( ap, vol )
            in
            Random.map3
                mkPrim
                (Random.uniform p ps)
                (Random.uniform d ds)
                (Random.int 0 127)

        _ ->
            Random.constant empty
