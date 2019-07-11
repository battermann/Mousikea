module Mousikea.Midi.MEvent exposing
    ( DurT
    , MContext
    , MEvent
    , PTime
    , Performance
    , perform1
    , perform1Dur
    , performAbsPitch
    , performAbsPitchVol
    , performNote1
    , performPitch
    , performPitchVol
    )

import Mousikea.Music
    exposing
        ( absPitch
        , fromAbsPitch
        , fromAbsPitchVolume
        , fromNote1
        , fromPitch
        , fromPitchVolume
        , qn
        , scaleDurations
        , shiftPitches1
        , zero
        )
import Mousikea.Types
    exposing
        ( AbsPitch
        , Articulation(..)
        , Control(..)
        , Dur
        , Dynamic(..)
        , InstrumentName(..)
        , Mode(..)
        , Music(..)
        , Music1
        , Note1
        , NoteAttribute(..)
        , NoteHead(..)
        , Ornament(..)
        , PhraseAttribute(..)
        , Pitch
        , PitchClass(..)
        , Primitive(..)
        , StdLoudness(..)
        , Tempo(..)
        , Volume
        )
import Mousikea.Util.Ratio as Ratio exposing (Rational, add, div, divIntBy, fromInt, max, mul, mulByInt, sub)


type alias Performance =
    List MEvent


type alias PTime =
    Rational


type alias DurT =
    Rational


type alias MEvent =
    { eTime : PTime
    , eInst : InstrumentName
    , ePitch : AbsPitch
    , eDur : DurT
    , eVol : Volume
    , eParams : List Float
    }


type alias MContext =
    { mcTime : PTime
    , mcInst : InstrumentName
    , mcDur : DurT
    , mcVol : Volume
    }


merge : Performance -> Performance -> Performance
merge es1 es2 =
    case ( es1, es2 ) of
        ( [], es2_ ) ->
            es2_

        ( es1_, [] ) ->
            es1_

        ( h1 :: t1, h2 :: t2 ) ->
            if Ratio.lt h1.eTime h2.eTime then
                h1 :: merge t1 es2

            else
                h2 :: merge es1 t2


performPitch : Music Pitch -> Performance
performPitch =
    perform1 << fromPitch


performPitchVol : Music ( Pitch, Volume ) -> Performance
performPitchVol =
    perform1 << fromPitchVolume


performAbsPitch : Music AbsPitch -> Performance
performAbsPitch =
    perform1 << fromAbsPitch


performAbsPitchVol : Music ( AbsPitch, Volume ) -> Performance
performAbsPitchVol =
    perform1 << fromAbsPitchVolume


performNote1 : Music Note1 -> Performance
performNote1 =
    perform1 << fromNote1


perform1 : Music1 -> Performance
perform1 =
    Tuple.first << perform1Dur


perform1Dur : Music1 -> ( Performance, DurT )
perform1Dur =
    let
        -- timing musicToMEventss
        metro : Int -> Dur -> DurT
        metro setting dur =
            divIntBy 60 (mulByInt dur setting)

        defCon =
            { mcTime = fromInt 0, mcInst = AcousticGrandPiano, mcDur = metro 120 qn, mcVol = 127 }
    in
    musicToMEvents defCon << applyControls


applyControls : Music1 -> Music1
applyControls m =
    case m of
        Modify (Tempo r) m_ ->
            scaleDurations r (applyControls m_)

        Modify (Transpose k) m_ ->
            shiftPitches1 k (applyControls m_)

        Modify x m_ ->
            Modify x (applyControls m_)

        Seq m1 m2 ->
            Seq (applyControls m1) (applyControls m2)

        Par m1 m2 ->
            Par (applyControls m1) (applyControls m2)

        x ->
            x


musicToMEvents : MContext -> Music1 -> ( Performance, DurT )
musicToMEvents ctx m =
    case m of
        Prim (Note dur p) ->
            ( [ noteToMEvent ctx dur p ], mul dur ctx.mcDur )

        Prim (Rest dur) ->
            ( [], mul dur ctx.mcDur )

        Seq m1 m2 ->
            let
                ( evs1, d1 ) =
                    musicToMEvents ctx m1

                ( evs2, d2 ) =
                    musicToMEvents { ctx | mcTime = add ctx.mcTime d1 } m2
            in
            ( evs1 ++ evs2, add d1 d2 )

        Par m1 m2 ->
            let
                ( evs1, d1 ) =
                    musicToMEvents ctx m1

                ( evs2, d2 ) =
                    musicToMEvents ctx m2
            in
            ( merge evs1 evs2, max d1 d2 )

        Modify (Instrument i) m_ ->
            musicToMEvents { ctx | mcInst = i } m_

        Modify (Phrase pas) m_ ->
            phraseToMEvents ctx pas m_

        Modify (KeySig _ _) m_ ->
            -- KeySig causes no change
            musicToMEvents ctx m_

        Modify (Custom _) m_ ->
            -- Custom causes no change
            musicToMEvents ctx m_

        Modify _ m_ ->
            -- Transpose and Tempo addressed by applyControls
            musicToMEvents ctx (applyControls m_)


noteToMEvent : MContext -> Dur -> ( Pitch, List NoteAttribute ) -> MEvent
noteToMEvent ctx dur ( p, nas ) =
    let
        nasFun : NoteAttribute -> MEvent -> MEvent
        nasFun na ev =
            case na of
                Volume v ->
                    { ev | eVol = v }

                Params pms ->
                    { ev | eParams = pms }

                _ ->
                    ev

        e0 =
            { eTime = ctx.mcTime
            , ePitch = absPitch p
            , eInst = ctx.mcInst
            , eDur = mul dur ctx.mcDur
            , eVol = ctx.mcVol
            , eParams = []
            }
    in
    List.foldr nasFun e0 nas


phraseToMEvents : MContext -> List PhraseAttribute -> Music1 -> ( Performance, DurT )
phraseToMEvents ctx pas m =
    case pas of
        [] ->
            musicToMEvents ctx m

        h :: t ->
            let
                ( pf, dur ) =
                    phraseToMEvents ctx t m

                loud x =
                    phraseToMEvents ctx (Dyn (Loudness (fromInt x)) :: t) m

                stretch x =
                    let
                        t0 =
                            List.head pf |> Maybe.map .eTime |> Maybe.withDefault zero

                        r =
                            div x dur

                        upd ev =
                            let
                                dt =
                                    sub ev.eTime t0

                                t_ =
                                    add
                                        (mul
                                            (add (fromInt 1) (mul dt r))
                                            dt
                                        )
                                        t0

                                d_ =
                                    mul
                                        (add
                                            (fromInt 1)
                                            (mul
                                                (add
                                                    (mul
                                                        (fromInt 2)
                                                        dt
                                                    )
                                                    ev.eDur
                                                )
                                                r
                                            )
                                        )
                                        ev.eDur
                            in
                            { ev | eTime = t_, eDur = d_ }
                    in
                    ( List.map upd pf, mul (add (fromInt 1) x) dur )

                inflate x =
                    let
                        t0 =
                            List.head pf |> Maybe.map .eTime |> Maybe.withDefault zero

                        r =
                            div x dur

                        upd ev =
                            { ev
                                | eVol =
                                    mul
                                        (add
                                            (fromInt 1)
                                            (mul
                                                (sub ev.eTime t0)
                                                r
                                            )
                                        )
                                        (fromInt ev.eVol)
                                        |> Ratio.round
                            }
                    in
                    ( List.map upd pf, dur )
            in
            case h of
                Dyn (Accent x) ->
                    ( List.map (\e -> { e | eVol = mul x (fromInt e.eVol) |> Ratio.round }) pf, dur )

                Dyn (StdLoudness l) ->
                    case l of
                        PPP ->
                            loud 40

                        PP ->
                            loud 50

                        P ->
                            loud 60

                        MP ->
                            loud 70

                        SF ->
                            loud 80

                        MF ->
                            loud 90

                        NF ->
                            loud 100

                        FF ->
                            loud 110

                        FFF ->
                            loud 120

                Dyn (Loudness x) ->
                    phraseToMEvents { ctx | mcVol = Ratio.round x } t m

                Dyn (Crescendo x) ->
                    inflate x

                Dyn (Diminuendo x) ->
                    inflate (mul (fromInt -1) x)

                Tmp (Ritardando x) ->
                    stretch x

                Tmp (Accelerando x) ->
                    stretch (mul (fromInt -1) x)

                Art (Staccato x) ->
                    ( List.map (\e -> { e | eDur = mul x e.eDur }) pf, dur )

                Art (Legato x) ->
                    ( List.map (\e -> { e | eDur = mul x e.eDur }) pf, dur )

                Art (Slurred x) ->
                    let
                        lastStartTime =
                            List.foldr (\e acc -> max e.eTime acc) zero pf

                        setDur e =
                            if Ratio.lt e.eTime lastStartTime then
                                { e | eDur = mul x e.eDur }

                            else
                                e
                    in
                    ( List.map setDur pf, dur )

                Art _ ->
                    -- not supported
                    ( pf, dur )

                Orn _ ->
                    -- not supported
                    ( pf, dur )