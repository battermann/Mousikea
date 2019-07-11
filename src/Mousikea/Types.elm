module Mousikea.Types exposing
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

import Mousikea.Util.Ratio exposing (Rational)


type PitchClass
    = Cff
    | Cf
    | C
    | Dff
    | Cs
    | Df
    | Css
    | D
    | Eff
    | Ds
    | Ef
    | Fff
    | Dss
    | E
    | Ff
    | Es
    | F
    | Gff
    | Ess
    | Fs
    | Gf
    | Fss
    | G
    | Aff
    | Gs
    | Af
    | Gss
    | A
    | Bff
    | As
    | Bf
    | Ass
    | B
    | Bs
    | Bss


type alias AbsPitch =
    Int


type alias Octave =
    Int


type alias Pitch =
    ( PitchClass, Octave )


type alias Dur =
    Rational


type Primitive a
    = Note Dur a
    | Rest Dur


type Music a
    = Prim (Primitive a) --  primitive value
    | Seq (Music a) (Music a) --  sequential composition
    | Par (Music a) (Music a) --  parallel composition
    | Modify Control (Music a) --  modifier


type Control
    = Tempo Rational --  scale the tempo
    | Transpose AbsPitch --  transposition
    | Instrument InstrumentName --  instrument label
    | Phrase (List PhraseAttribute) --  phrase attributes
    | KeySig PitchClass Mode --  key signature and mode
    | Custom String --  for user-specified controls


type Mode
    = Major
    | Minor
    | Ionian
    | Dorian
    | Phrygian
    | Lydian
    | Mixolydian
    | Aeolian
    | Locrian
    | CustomMode String


type InstrumentName
    = AcousticGrandPiano
    | BrightAcousticPiano
    | ElectricGrandPiano
    | HonkyTonkPiano
    | RhodesPiano
    | ChorusedPiano
    | Harpsichord
    | Clavinet
    | Celesta
    | Glockenspiel
    | MusicBox
    | Vibraphone
    | Marimba
    | Xylophone
    | TubularBells
    | Dulcimer
    | HammondOrgan
    | PercussiveOrgan
    | RockOrgan
    | ChurchOrgan
    | ReedOrgan
    | Accordion
    | Harmonica
    | TangoAccordion
    | AcousticGuitarNylon
    | AcousticGuitarSteel
    | ElectricGuitarJazz
    | ElectricGuitarClean
    | ElectricGuitarMuted
    | OverdrivenGuitar
    | DistortionGuitar
    | GuitarHarmonics
    | AcousticBass
    | ElectricBassFingered
    | ElectricBassPicked
    | FretlessBass
    | SlapBass1
    | SlapBass2
    | SynthBass1
    | SynthBass2
    | Violin
    | Viola
    | Cello
    | Contrabass
    | TremoloStrings
    | PizzicatoStrings
    | OrchestralHarp
    | Timpani
    | StringEnsemble1
    | StringEnsemble2
    | SynthStrings1
    | SynthStrings2
    | ChoirAahs
    | VoiceOohs
    | SynthVoice
    | OrchestraHit
    | Trumpet
    | Trombone
    | Tuba
    | MutedTrumpet
    | FrenchHorn
    | BrassSection
    | SynthBrass1
    | SynthBrass2
    | SopranoSax
    | AltoSax
    | TenorSax
    | BaritoneSax
    | Oboe
    | Bassoon
    | EnglishHorn
    | Clarinet
    | Piccolo
    | Flute
    | Recorder
    | PanFlute
    | BlownBottle
    | Shakuhachi
    | Whistle
    | Ocarina
    | Lead1Square
    | Lead2Sawtooth
    | Lead3Calliope
    | Lead4Chiff
    | Lead5Charang
    | Lead6Voice
    | Lead7Fifths
    | Lead8BassLead
    | Pad1NewAge
    | Pad2Warm
    | Pad3Polysynth
    | Pad4Choir
    | Pad5Bowed
    | Pad6Metallic
    | Pad7Halo
    | Pad8Sweep
    | FX1Train
    | FX2Soundtrack
    | FX3Crystal
    | FX4Atmosphere
    | FX5Brightness
    | FX6Goblins
    | FX7Echoes
    | FX8SciFi
    | Sitar
    | Banjo
    | Shamisen
    | Koto
    | Kalimba
    | Bagpipe
    | Fiddle
    | Shanai
    | TinkleBell
    | Agogo
    | SteelDrums
    | Woodblock
    | TaikoDrum
    | MelodicDrum
    | SynthDrum
    | ReverseCymbal
    | GuitarFretNoise
    | BreathNoise
    | Seashore
    | BirdTweet
    | TelephoneRing
    | Helicopter
    | Applause
    | Gunshot
    | Percussion
    | CustomInstrument String


type PhraseAttribute
    = Dyn Dynamic
    | Tmp Tempo
    | Art Articulation
    | Orn Ornament


type Dynamic
    = Accent Rational
    | Crescendo Rational
    | Diminuendo Rational
    | StdLoudness StdLoudness
    | Loudness Rational


type StdLoudness
    = PPP
    | PP
    | P
    | MP
    | SF
    | MF
    | NF
    | FF
    | FFF


type Tempo
    = Ritardando Rational
    | Accelerando Rational


type Articulation
    = Staccato Rational
    | Legato Rational
    | Slurred Rational
    | Tenuto
    | Marcato
    | Pedal
    | Fermata
    | FermataDown
    | Breath
    | DownBow
    | UpBow
    | Harmonic
    | Pizzicato
    | LeftPizz
    | BartokPizz
    | Swell
    | Wedge
    | Thumb
    | Stopped


type Ornament
    = Trill
    | Mordent
    | InvMordent
    | DoubleMordent
    | Turn
    | TrilledTurn
    | ShortTrill
    | Arpeggio
    | ArpeggioUp
    | ArpeggioDown
    | Instruction String
    | Head NoteHead
    | DiatonicTrans Int


type NoteHead
    = DiamondHead
    | SquareHead
    | XHead
    | TriangleHead
    | TremoloHead
    | SlashHead
    | ArtHarmonic
    | NoHead


type alias Volume =
    Int


type NoteAttribute
    = Volume Int --  MIDI convention: 0=min, 127=max
    | Fingering Int
    | Dynamics String
    | Params (List Float)


type alias Note1 =
    ( Pitch, List NoteAttribute )


type alias Music1 =
    Music Note1
