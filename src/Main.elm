module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes
import Mousikea.Examples.ChildrenSong6 as ChildrenSong
import Mousikea.Examples.Drums as Drums
import Mousikea.Midi.MEvent as Perf exposing (Performance)
import WebAudioFont



---- MODEL ----


type alias Model =
    Dict String Performance


init : ( Model, Cmd Msg )
init =
    ( Dict.empty
        |> Dict.insert "1. Children's Songs No. 6 (Chick Corea)" (ChildrenSong.childSong6 |> Perf.performPitch)
        |> Dict.insert "2. Simple Drum Beat" (Drums.simpleBeat |> Perf.performPitch)
        |> Dict.insert "3. African Drum Beat" (Drums.africanDrumBeat |> Perf.performPitch)
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Play String
    | Stop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play key ->
            ( model, model |> Dict.get key |> Maybe.map WebAudioFont.queueWavTable |> Maybe.withDefault Cmd.none )

        Stop ->
            ( model, WebAudioFont.stop () )



---- VIEW ----


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
            [ Grid.col []
                [ Html.h1 [] [ Html.text "Making Music with Elm" ]
                , model
                    |> Dict.keys
                    |> List.map
                        (\key ->
                            Html.div []
                                [ Html.h3 [ Spacing.mt5 ] [ Html.text key ]
                                , Button.button [ Button.outlineSecondary, Button.onClick (Play key) ] [ Html.i [ Html.Attributes.class "fas fa-play" ] [] ]
                                , Button.button [ Button.attrs [ Spacing.ml2 ], Button.outlineSecondary, Button.onClick Stop ] [ Html.i [ Html.Attributes.class "fas fa-stop" ] [] ]
                                ]
                        )
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
