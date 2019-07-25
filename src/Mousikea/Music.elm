module Mousikea.Music exposing
    ( a
    , absPitch
    , af
    , aff
    , as_
    , ass
    , b
    , bf
    , bff
    , bn
    , bnr
    , bs
    , bss
    , c
    , cf
    , cff
    , changeInstrument
    , chord
    , cs
    , css
    , cut
    , d
    , dden
    , ddenr
    , ddhn
    , ddhnr
    , ddqn
    , ddqnr
    , den
    , denr
    , df
    , dff
    , dhn
    , dhnr
    , dqn
    , dqnr
    , ds
    , dsn
    , dsnr
    , dss
    , dtn
    , dtnr
    , duration
    , dwn
    , dwnr
    , e_
    , ef
    , eff
    , empty
    , en
    , enr
    , es
    , ess
    , f
    , ff
    , fff
    , flip
    , fromAbsPitch
    , fromAbsPitchVolume
    , fromNote1
    , fromPitch
    , fromPitchVolume
    , fs
    , fss
    , g
    , gf
    , gff
    , gs
    , gss
    , hn
    , hnr
    , indexToPitchClass
    , instrument
    , invert
    , invert1
    , invertAt
    , invertAt1
    , invertRetro
    , isZero
    , keysig
    , line
    , lineToList
    , mFold
    , mMap
    , note
    , offset
    , pMap
    , pcToInt
    , perc
    , phrase
    , pitch
    , qn
    , qnr
    , remove
    , removeInstruments
    , removeZeros
    , rest
    , retro
    , retroInvert
    , scaleDurations
    , sfn
    , sfnr
    , shiftPitches
    , shiftPitches1
    , sn
    , snr
    , tempo
    , times
    , tn
    , tnr
    , trans
    , transpose
    , wn
    , wnr
    , zero
    )

import Mousikea.PercussionSound as Perc exposing (PercussionSound)
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
        , Octave
        , Ornament(..)
        , PhraseAttribute(..)
        , Pitch
        , PitchClass(..)
        , Primitive(..)
        , StdLoudness(..)
        , Tempo(..)
        , Volume
        )
import Mousikea.Util.Ratio as Ratio exposing (Rational, add, div, fromInt, isZero, max, min, mul, over, sub)



---- Music1 Conversions ----


fromPitch : Music Pitch -> Music1
fromPitch =
    mMap (\p -> ( p, [] ))


fromPitchVolume : Music ( Pitch, Volume ) -> Music1
fromPitchVolume =
    mMap (\( p, v ) -> ( p, [ Volume v ] ))


fromNote1 : Music Note1 -> Music1
fromNote1 =
    identity


fromAbsPitch : Music AbsPitch -> Music1
fromAbsPitch =
    mMap (\ap -> ( pitch ap, [] ))


fromAbsPitchVolume : Music ( AbsPitch, Volume ) -> Music1
fromAbsPitchVolume =
    mMap (\( ap, v ) -> ( pitch ap, [ Volume v ] ))



----


note : Dur -> a -> Music a
note dur p =
    Prim (Note dur p)


rest : Dur -> Music a
rest dur =
    Prim (Rest dur)


tempo : Dur -> Music a -> Music a
tempo r m =
    Modify (Tempo r) m


transpose : AbsPitch -> Music a -> Music a
transpose i m =
    Modify (Transpose i) m


instrument : InstrumentName -> Music a -> Music a
instrument i m =
    Modify (Instrument i) m


phrase : List PhraseAttribute -> Music a -> Music a
phrase pa m =
    Modify (Phrase pa) m


keysig : PitchClass -> Mode -> Music a -> Music a
keysig pc mo m =
    Modify (KeySig pc mo) m


cff : Octave -> Dur -> Music Pitch
cff octave dur =
    note dur ( Cff, octave )


cf : Octave -> Dur -> Music Pitch
cf octave dur =
    note dur ( Cf, octave )


c : Octave -> Dur -> Music Pitch
c octave dur =
    note dur ( C, octave )


cs : Octave -> Dur -> Music Pitch
cs octave dur =
    note dur ( Cs, octave )


css : Octave -> Dur -> Music Pitch
css octave dur =
    note dur ( Css, octave )


dff : Octave -> Dur -> Music Pitch
dff octave dur =
    note dur ( Dff, octave )


df : Octave -> Dur -> Music Pitch
df octave dur =
    note dur ( Df, octave )


d : Octave -> Dur -> Music Pitch
d octave dur =
    note dur ( D, octave )


ds : Octave -> Dur -> Music Pitch
ds octave dur =
    note dur ( Ds, octave )


dss : Octave -> Dur -> Music Pitch
dss octave dur =
    note dur ( Dss, octave )


eff : Octave -> Dur -> Music Pitch
eff octave dur =
    note dur ( Eff, octave )


ef : Octave -> Dur -> Music Pitch
ef octave dur =
    note dur ( Ef, octave )


e_ : Octave -> Dur -> Music Pitch
e_ octave dur =
    note dur ( E, octave )


es : Octave -> Dur -> Music Pitch
es octave dur =
    note dur ( Es, octave )


ess : Octave -> Dur -> Music Pitch
ess octave dur =
    note dur ( Ess, octave )


fff : Octave -> Dur -> Music Pitch
fff octave dur =
    note dur ( Fff, octave )


ff : Octave -> Dur -> Music Pitch
ff octave dur =
    note dur ( Ff, octave )


f : Octave -> Dur -> Music Pitch
f octave dur =
    note dur ( F, octave )


fs : Octave -> Dur -> Music Pitch
fs octave dur =
    note dur ( Fs, octave )


fss : Octave -> Dur -> Music Pitch
fss octave dur =
    note dur ( Fss, octave )


gff : Octave -> Dur -> Music Pitch
gff octave dur =
    note dur ( Gff, octave )


gf : Octave -> Dur -> Music Pitch
gf octave dur =
    note dur ( Gf, octave )


g : Octave -> Dur -> Music Pitch
g octave dur =
    note dur ( G, octave )


gs : Octave -> Dur -> Music Pitch
gs octave dur =
    note dur ( Gs, octave )


gss : Octave -> Dur -> Music Pitch
gss octave dur =
    note dur ( Gss, octave )


aff : Octave -> Dur -> Music Pitch
aff octave dur =
    note dur ( Aff, octave )


af : Octave -> Dur -> Music Pitch
af octave dur =
    note dur ( Af, octave )


a : Octave -> Dur -> Music Pitch
a octave dur =
    note dur ( A, octave )


as_ : Octave -> Dur -> Music Pitch
as_ octave dur =
    note dur ( As, octave )


ass : Octave -> Dur -> Music Pitch
ass octave dur =
    note dur ( Ass, octave )


bff : Octave -> Dur -> Music Pitch
bff octave dur =
    note dur ( Bff, octave )


bf : Octave -> Dur -> Music Pitch
bf octave dur =
    note dur ( Bf, octave )


b : Octave -> Dur -> Music Pitch
b octave dur =
    note dur ( B, octave )


bs : Octave -> Dur -> Music Pitch
bs octave dur =
    note dur ( Bs, octave )


bss : Octave -> Dur -> Music Pitch
bss octave dur =
    note dur ( Bss, octave )


bn : Dur
bn =
    fromInt 2


{-| brevis rests
-}
bnr : Music Pitch
bnr =
    rest bn


wn : Dur
wn =
    fromInt 1


{-| whole note rest
-}
wnr : Music Pitch
wnr =
    rest wn


hn : Dur
hn =
    over 1 2


{-| half note rest
-}
hnr : Music Pitch
hnr =
    rest hn


qn : Dur
qn =
    over 1 4


{-| quarter note rest
-}
qnr : Music Pitch
qnr =
    rest qn


en : Dur
en =
    over 1 8


{-| eighth note rest
-}
enr : Music Pitch
enr =
    rest en


sn : Dur
sn =
    over 1 16


{-| sixteenth note rest
-}
snr : Music Pitch
snr =
    rest sn


tn : Dur
tn =
    over 1 32


{-| thirty-second note rest
-}
tnr : Music Pitch
tnr =
    rest tn


sfn : Dur
sfn =
    over 1 64


{-| sixty-fourth note rest
-}
sfnr : Music Pitch
sfnr =
    rest sfn


dwn : Dur
dwn =
    over 3 2


{-| dotted whole note rest
-}
dwnr : Music Pitch
dwnr =
    rest dwn


dhn : Dur
dhn =
    over 3 4


{-| dotted half note rest
-}
dhnr : Music Pitch
dhnr =
    rest dhn


dqn : Dur
dqn =
    over 3 8


{-| dotted quarter note rest
-}
dqnr : Music Pitch
dqnr =
    rest dqn


den : Dur
den =
    over 3 16


{-| dotted eighth note rest
-}
denr : Music Pitch
denr =
    rest den


dsn : Dur
dsn =
    over 3 32


{-| dotted sixteenth note rest
-}
dsnr : Music Pitch
dsnr =
    rest dsn


dtn : Dur
dtn =
    over 3 64


{-| dotted thirty-second note rest
-}
dtnr : Music Pitch
dtnr =
    rest dtn


ddhn : Dur
ddhn =
    over 7 8


{-| double-dotted half note rest
-}
ddhnr : Music Pitch
ddhnr =
    rest ddhn


ddqn : Dur
ddqn =
    over 7 16


{-| double-dotted quarter note rest
-}
ddqnr : Music Pitch
ddqnr =
    rest ddqn


dden : Dur
dden =
    over 7 32


{-| double-dotted eighth note rest
-}
ddenr : Music Pitch
ddenr =
    rest dden


zero : Dur
zero =
    fromInt 0


{-| a rest with duration zero
-}
empty : Music a
empty =
    rest zero


absPitch : Pitch -> AbsPitch
absPitch ( pc, oct ) =
    12 * (oct + 1) + pcToInt pc


pcToInt : PitchClass -> Int
pcToInt pc =
    case pc of
        Cff ->
            -2

        Cf ->
            -1

        C ->
            0

        Cs ->
            1

        Css ->
            2

        Dff ->
            0

        Df ->
            1

        D ->
            2

        Ds ->
            3

        Dss ->
            4

        Eff ->
            2

        Ef ->
            3

        E ->
            4

        Es ->
            5

        Ess ->
            6

        Fff ->
            3

        Ff ->
            4

        F ->
            5

        Fs ->
            6

        Fss ->
            7

        Gff ->
            5

        Gf ->
            6

        G ->
            7

        Gs ->
            8

        Gss ->
            9

        Aff ->
            7

        Af ->
            8

        A ->
            9

        As ->
            10

        Ass ->
            11

        Bff ->
            9

        Bf ->
            10

        B ->
            11

        Bs ->
            12

        Bss ->
            13


pitch : AbsPitch -> Pitch
pitch ap =
    let
        ( oct, n ) =
            ( ap // 12
            , ap |> modBy 12
            )
    in
    ( indexToPitchClass n, oct - 1 )


indexToPitchClass : Int -> PitchClass
indexToPitchClass n =
    case n of
        0 ->
            C

        1 ->
            Cs

        2 ->
            D

        3 ->
            Ds

        4 ->
            E

        5 ->
            F

        6 ->
            Fs

        7 ->
            G

        8 ->
            Gs

        9 ->
            A

        10 ->
            As

        11 ->
            B

        other ->
            if other > 0 then
                indexToPitchClass (other - 12)

            else
                indexToPitchClass (other + 12)


trans : Int -> Pitch -> Pitch
trans i p =
    pitch (absPitch p + i)


line : List (Music a) -> Music a
line =
    List.foldr Seq empty


chord : List (Music a) -> Music a
chord =
    List.foldr Par empty


offset : Dur -> Music a -> Music a
offset dur m =
    Seq (rest dur) m


times : Int -> Music a -> Music a
times n m =
    if n <= 0 then
        empty

    else
        Seq m (times (n - 1) m)


lineToList : Music a -> List (Music a)
lineToList m =
    case m of
        Prim (Rest dur) ->
            if Ratio.isZero dur then
                []

            else
                [ Prim (Rest dur) ]

        Prim m_ ->
            [ Prim m_ ]

        Seq n ns ->
            n :: lineToList ns

        Par _ _ ->
            []

        Modify _ m_ ->
            lineToList m_


pMap : (a -> b) -> Primitive a -> Primitive b
pMap func prim =
    case prim of
        Note dur x ->
            Note dur (func x)

        Rest dur ->
            Rest dur


mMap : (a -> b) -> Music a -> Music b
mMap func m =
    case m of
        Prim p ->
            Prim (pMap func p)

        Seq m1 m2 ->
            Seq (mMap func m1) (mMap func m2)

        Par m1 m2 ->
            Par (mMap func m1) (mMap func m2)

        Modify control m_ ->
            Modify control (mMap func m_)


invertAt : Pitch -> Music Pitch -> Music Pitch
invertAt pRef =
    mMap (\p -> pitch (2 * absPitch pRef - absPitch p))


invertAt1 : Pitch -> Music ( Pitch, a ) -> Music ( Pitch, a )
invertAt1 pRef =
    mMap (\( p, x ) -> ( pitch (2 * absPitch pRef - absPitch p), x ))


invert : Music Pitch -> Music Pitch
invert m =
    let
        pFun m_ =
            case m_ of
                Note _ p ->
                    [ p ]

                _ ->
                    []

        pRef =
            mFold pFun (++) (++) (flip always) m
    in
    case pRef of
        [] ->
            -- no pitches in the structure!
            m

        h :: _ ->
            invertAt h m


flip : (a -> b -> c) -> (b -> a -> c)
flip fun =
    \y x -> fun x y


invert1 : Music ( Pitch, a ) -> Music ( Pitch, a )
invert1 m =
    let
        pFun m_ =
            case m_ of
                Note _ ( p, _ ) ->
                    [ p ]

                _ ->
                    []

        pRef =
            mFold pFun (++) (++) (flip always) m
    in
    case pRef of
        -- no pitches!
        [] ->
            m

        h :: _ ->
            invertAt1 h m


retro : Music a -> Music a
retro m =
    case m of
        Prim x ->
            Prim x

        Modify control m_ ->
            Modify control (retro m_)

        Seq m1 m2 ->
            Seq (retro m2) (retro m1)

        Par m1 m2 ->
            let
                d1 =
                    duration m1

                d2 =
                    duration m2
            in
            if Ratio.gt d1 d2 then
                Par (retro m1) (Seq (rest (sub d1 d2)) (retro m2))

            else
                Par (Seq (rest (sub d2 d1)) (retro m1)) (retro m2)


retroInvert : Music Pitch -> Music Pitch
retroInvert =
    retro << invert


invertRetro : Music Pitch -> Music Pitch
invertRetro =
    invert << retro


duration : Music a -> Dur
duration m =
    case m of
        Prim (Note dur _) ->
            dur

        Prim (Rest dur) ->
            dur

        Seq m1 m2 ->
            add (duration m1) (duration m2)

        Par m1 m2 ->
            max (duration m1) (duration m2)

        Modify (Tempo r) m_ ->
            div (duration m_) r

        Modify _ m_ ->
            duration m_


cut : Dur -> Music a -> Music a
cut dur m =
    if Ratio.le dur zero then
        empty

    else
        case m of
            Prim (Note oldD p) ->
                let
                    dur_ =
                        max (min oldD dur) zero
                in
                if Ratio.gt dur_ zero then
                    note dur_ p

                else
                    empty

            Prim (Rest oldD) ->
                rest (max (min oldD dur) zero)

            Par m1 m2 ->
                Par (cut dur m1) (cut dur m2)

            Seq m1 m2 ->
                let
                    music1 =
                        cut dur m1

                    music2 =
                        cut (sub dur (duration music1)) m2
                in
                Seq music1 music2

            Modify (Tempo r) m_ ->
                tempo r (cut (mul dur r) m_)

            Modify control m_ ->
                Modify control (cut dur m_)


remove : Dur -> Music a -> Music a
remove dur m =
    if Ratio.le dur zero then
        m

    else
        case m of
            Prim (Note oldD p) ->
                let
                    d_ =
                        max (sub oldD dur) zero
                in
                if Ratio.gt d_ zero then
                    note d_ p

                else
                    empty

            Prim (Rest oldD) ->
                rest (max (sub oldD dur) zero)

            Par m1 m2 ->
                Par (remove dur m1) (remove dur m2)

            Seq m1 m2 ->
                let
                    m_1 =
                        remove dur m1

                    m_2 =
                        remove (sub dur (duration m1)) m2
                in
                Seq m_1 m_2

            Modify (Tempo r) m_ ->
                tempo r (remove (mul dur r) m_)

            Modify control m_ ->
                Modify control (remove dur m_)


isZero : Music a -> Bool
isZero =
    duration >> Ratio.isZero


removeZeros : Music a -> Music a
removeZeros m =
    case m of
        Prim p ->
            Prim p

        Seq m1 m2 ->
            let
                m_1 =
                    removeZeros m1

                m_2 =
                    removeZeros m2
            in
            if isZero m_1 then
                m_2

            else if isZero m_2 then
                m_1

            else
                Seq m_1 m_2

        Par m1 m2 ->
            let
                m_1 =
                    removeZeros m1

                m_2 =
                    removeZeros m2
            in
            if isZero m_1 then
                m_2

            else if isZero m_2 then
                m_1

            else
                Par m_1 m_2

        Modify control m_ ->
            Modify control (removeZeros m_)


perc : PercussionSound -> Dur -> Music Pitch
perc ps dur =
    instrument Percussion (note dur (pitch (Perc.fromEnum ps + 35)))


mFold : (Primitive a -> b) -> (b -> b -> b) -> (b -> b -> b) -> (Control -> b -> b) -> Music a -> b
mFold func onSeq onPar func2 m =
    let
        rec =
            mFold func onSeq onPar func2
    in
    case m of
        Prim p ->
            func p

        Seq m1 m2 ->
            onSeq (rec m1) (rec m2)

        Par m1 m2 ->
            onPar (rec m1) (rec m2)

        Modify control m_ ->
            func2 control (rec m_)



---- Sometimes we may wish to alter the internal structure of a Music value ----
---- rather than wrapping it with Modify. The following functions allow this. ----


shiftPitches : AbsPitch -> Music Pitch -> Music Pitch
shiftPitches k =
    mMap (trans k)


shiftPitches1 : AbsPitch -> Music ( Pitch, b ) -> Music ( Pitch, b )
shiftPitches1 k =
    mMap (\( p, xs ) -> ( trans k p, xs ))


scaleDurations : Rational -> Music a -> Music a
scaleDurations r m =
    case m of
        Prim (Note dur p) ->
            note (div dur r) p

        Prim (Rest dur) ->
            rest (div dur r)

        Seq m1 m2 ->
            Seq (scaleDurations r m1) (scaleDurations r m2)

        Par m1 m2 ->
            Par (scaleDurations r m1) (scaleDurations r m2)

        Modify control m_ ->
            Modify control (scaleDurations r m_)


changeInstrument : InstrumentName -> Music a -> Music a
changeInstrument i m =
    Modify (Instrument i) (removeInstruments m)


removeInstruments : Music a -> Music a
removeInstruments m =
    case m of
        Modify (Instrument _) m_ ->
            removeInstruments m_

        Modify control m_ ->
            Modify control (removeInstruments m_)

        Seq m1 m2 ->
            Seq (removeInstruments m1) (removeInstruments m2)

        Par m1 m2 ->
            Par (removeInstruments m1) (removeInstruments m2)

        other ->
            other
