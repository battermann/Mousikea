module Mousikea.Midi.GeneralMidi exposing (fromEnum, fromGM, toEnum, toGM)

import Mousikea.Types exposing (InstrumentName(..))


fromGM : Int -> InstrumentName
fromGM i =
    toEnum i


toGM : InstrumentName -> Int
toGM instrumentName =
    case instrumentName of
        Percussion ->
            0

        CustomInstrument _ ->
            0

        i ->
            fromEnum i


fromEnum : InstrumentName -> Int
fromEnum instrumentName =
    case instrumentName of
        AcousticGrandPiano ->
            0

        BrightAcousticPiano ->
            1

        ElectricGrandPiano ->
            2

        HonkyTonkPiano ->
            3

        RhodesPiano ->
            4

        ChorusedPiano ->
            5

        Harpsichord ->
            6

        Clavinet ->
            7

        Celesta ->
            8

        Glockenspiel ->
            9

        MusicBox ->
            10

        Vibraphone ->
            11

        Marimba ->
            12

        Xylophone ->
            13

        TubularBells ->
            14

        Dulcimer ->
            15

        HammondOrgan ->
            16

        PercussiveOrgan ->
            17

        RockOrgan ->
            18

        ChurchOrgan ->
            19

        ReedOrgan ->
            20

        Accordion ->
            21

        Harmonica ->
            22

        TangoAccordion ->
            23

        AcousticGuitarNylon ->
            24

        AcousticGuitarSteel ->
            25

        ElectricGuitarJazz ->
            26

        ElectricGuitarClean ->
            27

        ElectricGuitarMuted ->
            28

        OverdrivenGuitar ->
            29

        DistortionGuitar ->
            30

        GuitarHarmonics ->
            31

        AcousticBass ->
            32

        ElectricBassFingered ->
            33

        ElectricBassPicked ->
            34

        FretlessBass ->
            35

        SlapBass1 ->
            36

        SlapBass2 ->
            37

        SynthBass1 ->
            38

        SynthBass2 ->
            39

        Violin ->
            40

        Viola ->
            41

        Cello ->
            42

        Contrabass ->
            43

        TremoloStrings ->
            44

        PizzicatoStrings ->
            45

        OrchestralHarp ->
            46

        Timpani ->
            47

        StringEnsemble1 ->
            48

        StringEnsemble2 ->
            49

        SynthStrings1 ->
            50

        SynthStrings2 ->
            51

        ChoirAahs ->
            52

        VoiceOohs ->
            53

        SynthVoice ->
            54

        OrchestraHit ->
            55

        Trumpet ->
            56

        Trombone ->
            57

        Tuba ->
            58

        MutedTrumpet ->
            59

        FrenchHorn ->
            60

        BrassSection ->
            61

        SynthBrass1 ->
            62

        SynthBrass2 ->
            63

        SopranoSax ->
            64

        AltoSax ->
            65

        TenorSax ->
            66

        BaritoneSax ->
            67

        Oboe ->
            68

        EnglishHorn ->
            69

        Bassoon ->
            70

        Clarinet ->
            71

        Piccolo ->
            72

        Flute ->
            73

        Recorder ->
            74

        PanFlute ->
            75

        BlownBottle ->
            76

        Shakuhachi ->
            77

        Whistle ->
            78

        Ocarina ->
            79

        Lead1Square ->
            80

        Lead2Sawtooth ->
            81

        Lead3Calliope ->
            82

        Lead4Chiff ->
            83

        Lead5Charang ->
            84

        Lead6Voice ->
            85

        Lead7Fifths ->
            86

        Lead8BassLead ->
            87

        Pad1NewAge ->
            88

        Pad2Warm ->
            89

        Pad3Polysynth ->
            90

        Pad4Choir ->
            91

        Pad5Bowed ->
            92

        Pad6Metallic ->
            93

        Pad7Halo ->
            94

        Pad8Sweep ->
            95

        FX1Train ->
            96

        FX2Soundtrack ->
            97

        FX3Crystal ->
            98

        FX4Atmosphere ->
            99

        FX5Brightness ->
            100

        FX6Goblins ->
            101

        FX7Echoes ->
            102

        FX8SciFi ->
            103

        Sitar ->
            104

        Banjo ->
            105

        Shamisen ->
            106

        Koto ->
            107

        Kalimba ->
            108

        Bagpipe ->
            109

        Fiddle ->
            110

        Shanai ->
            111

        TinkleBell ->
            112

        Agogo ->
            113

        SteelDrums ->
            114

        Woodblock ->
            115

        TaikoDrum ->
            116

        MelodicDrum ->
            117

        SynthDrum ->
            118

        ReverseCymbal ->
            119

        GuitarFretNoise ->
            120

        BreathNoise ->
            121

        Seashore ->
            122

        BirdTweet ->
            123

        TelephoneRing ->
            124

        Helicopter ->
            125

        Applause ->
            126

        Gunshot ->
            127

        Percussion ->
            0

        CustomInstrument _ ->
            0


toEnum : Int -> InstrumentName
toEnum i =
    case i of
        0 ->
            AcousticGrandPiano

        1 ->
            BrightAcousticPiano

        2 ->
            ElectricGrandPiano

        3 ->
            HonkyTonkPiano

        4 ->
            RhodesPiano

        5 ->
            ChorusedPiano

        6 ->
            Harpsichord

        7 ->
            Clavinet

        8 ->
            Celesta

        9 ->
            Glockenspiel

        10 ->
            MusicBox

        11 ->
            Vibraphone

        12 ->
            Marimba

        13 ->
            Xylophone

        14 ->
            TubularBells

        15 ->
            Dulcimer

        16 ->
            HammondOrgan

        17 ->
            PercussiveOrgan

        18 ->
            RockOrgan

        19 ->
            ChurchOrgan

        20 ->
            ReedOrgan

        21 ->
            Accordion

        22 ->
            Harmonica

        23 ->
            TangoAccordion

        24 ->
            AcousticGuitarNylon

        25 ->
            AcousticGuitarSteel

        26 ->
            ElectricGuitarJazz

        27 ->
            ElectricGuitarClean

        28 ->
            ElectricGuitarMuted

        29 ->
            OverdrivenGuitar

        30 ->
            DistortionGuitar

        31 ->
            GuitarHarmonics

        32 ->
            AcousticBass

        33 ->
            ElectricBassFingered

        34 ->
            ElectricBassPicked

        35 ->
            FretlessBass

        36 ->
            SlapBass1

        37 ->
            SlapBass2

        38 ->
            SynthBass1

        39 ->
            SynthBass2

        40 ->
            Violin

        41 ->
            Viola

        42 ->
            Cello

        43 ->
            Contrabass

        44 ->
            TremoloStrings

        45 ->
            PizzicatoStrings

        46 ->
            OrchestralHarp

        47 ->
            Timpani

        48 ->
            StringEnsemble1

        49 ->
            StringEnsemble2

        50 ->
            SynthStrings1

        51 ->
            SynthStrings2

        52 ->
            ChoirAahs

        53 ->
            VoiceOohs

        54 ->
            SynthVoice

        55 ->
            OrchestraHit

        56 ->
            Trumpet

        57 ->
            Trombone

        58 ->
            Tuba

        59 ->
            MutedTrumpet

        60 ->
            FrenchHorn

        61 ->
            BrassSection

        62 ->
            SynthBrass1

        63 ->
            SynthBrass2

        64 ->
            SopranoSax

        65 ->
            AltoSax

        66 ->
            TenorSax

        67 ->
            BaritoneSax

        68 ->
            Oboe

        69 ->
            EnglishHorn

        70 ->
            Bassoon

        71 ->
            Clarinet

        72 ->
            Piccolo

        73 ->
            Flute

        74 ->
            Recorder

        75 ->
            PanFlute

        76 ->
            BlownBottle

        77 ->
            Shakuhachi

        78 ->
            Whistle

        79 ->
            Ocarina

        80 ->
            Lead1Square

        81 ->
            Lead2Sawtooth

        82 ->
            Lead3Calliope

        83 ->
            Lead4Chiff

        84 ->
            Lead5Charang

        85 ->
            Lead6Voice

        86 ->
            Lead7Fifths

        87 ->
            Lead8BassLead

        88 ->
            Pad1NewAge

        89 ->
            Pad2Warm

        90 ->
            Pad3Polysynth

        91 ->
            Pad4Choir

        92 ->
            Pad5Bowed

        93 ->
            Pad6Metallic

        94 ->
            Pad7Halo

        95 ->
            Pad8Sweep

        96 ->
            FX1Train

        97 ->
            FX2Soundtrack

        98 ->
            FX3Crystal

        99 ->
            FX4Atmosphere

        100 ->
            FX5Brightness

        101 ->
            FX6Goblins

        102 ->
            FX7Echoes

        103 ->
            FX8SciFi

        104 ->
            Sitar

        105 ->
            Banjo

        106 ->
            Shamisen

        107 ->
            Koto

        108 ->
            Kalimba

        109 ->
            Bagpipe

        110 ->
            Fiddle

        111 ->
            Shanai

        112 ->
            TinkleBell

        113 ->
            Agogo

        114 ->
            SteelDrums

        115 ->
            Woodblock

        116 ->
            TaikoDrum

        117 ->
            MelodicDrum

        118 ->
            SynthDrum

        119 ->
            ReverseCymbal

        120 ->
            GuitarFretNoise

        121 ->
            BreathNoise

        122 ->
            Seashore

        123 ->
            BirdTweet

        124 ->
            TelephoneRing

        125 ->
            Helicopter

        126 ->
            Applause

        127 ->
            Gunshot

        n ->
            if n < 0 then
                toEnum (n + 127)

            else
                toEnum (n - 127)
