module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Events
import Json.Encode as Encode exposing (Value)
import Mousikea.Examples.ChildrenSong6 as ChildrenSong
import Mousikea.Midi.Encoder as Encoder
import Mousikea.Midi.MEvent as Perf exposing (MEvent, Performance)
import WebAudioFont



---- MODEL ----


type alias Model =
    Dict String Performance


init : ( Model, Cmd Msg )
init =
    ( Dict.empty
        |> Dict.insert "" (ChildrenSong.childSong6 |> Perf.performPitch)
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Play String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play key ->
            ( model, model |> Dict.get key |> Maybe.map WebAudioFont.queueWavTable |> Maybe.withDefault Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    model
        |> Dict.keys
        |> List.map (\key -> Html.button [ Html.Events.onClick (Play key) ] [ Html.text "Play!" ])
        |> Html.div []



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
