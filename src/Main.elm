module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes
import Mousikea.Examples.BlueLambda as BlueLambda
import Mousikea.Examples.ChildrenSong6 as ChildrenSong
import Mousikea.Examples.Drums as Drums
import Mousikea.Examples.SingASongOfSong as SingA
import Mousikea.Generator as Gen
import Mousikea.Midi.MEvent as Perf exposing (Performance)
import Random
import WebAudioFont



---- MODEL ----


type alias Model =
    { static : Dict String Performance
    , random : Dict String (Random.Generator Performance)
    }


init : ( Model, Cmd Msg )
init =
    ( { static =
            Dict.empty
                |> Dict.insert "1. Children's Songs No. 6 (Chick Corea)" (ChildrenSong.childSong6 |> Perf.performNote1)
                |> Dict.insert "2. Blue Lambda" (BlueLambda.blueLambda |> Perf.performNote1)
                |> Dict.insert "3. Simple Disco Drum Beat" (Drums.simpleBeat |> Perf.performNote1)
                |> Dict.insert "4. Sing A Song Of Song (Kenny Garrett)" (SingA.song |> Perf.performNote1)
      , random =
            Dict.empty
                |> Dict.insert "5. Randomness with Tonality and Volume" (Gen.randomness |> Random.map Perf.performAbsPitchVol)
                |> Dict.insert "6. Blue Bossa Jam" (Gen.blueBossa |> Random.map Perf.performNote1)
                |> Dict.insert "7. Random Bossa" (Gen.bossa |> Random.map Perf.performNote1)
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Play String
    | Generate String
    | Generated Performance
    | Stop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play key ->
            ( model, model.static |> Dict.get key |> Maybe.map WebAudioFont.queueWavTable |> Maybe.withDefault Cmd.none )

        Stop ->
            ( model, WebAudioFont.stop () )

        Generate key ->
            ( model, model.random |> Dict.get key |> Maybe.map (Random.generate Generated) |> Maybe.withDefault Cmd.none )

        Generated performance ->
            ( model, WebAudioFont.queueWavTable performance )



---- VIEW ----


viewSong : (String -> Msg) -> String -> Html Msg
viewSong msg key =
    Html.div [ Spacing.mt5 ]
        [ Html.h3 [ Spacing.mt5 ] [ Html.text key ]
        , Button.button [ Button.primary, Button.onClick (msg key) ] [ Html.i [ Html.Attributes.class "fas fa-play" ] [] ]
        , Button.button [ Button.attrs [ Spacing.ml2 ], Button.primary, Button.onClick Stop ] [ Html.i [ Html.Attributes.class "fas fa-stop" ] [] ]
        ]


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
            [ Grid.col []
                [ Html.h1 [] [ Html.text "Making Music with Elm" ]
                , model.static
                    |> Dict.keys
                    |> List.map (viewSong Play)
                    |> Html.div []
                , model.random
                    |> Dict.keys
                    |> List.map (viewSong Generate)
                    |> Html.div []
                ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
