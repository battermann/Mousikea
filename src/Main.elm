port module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Events
import Json.Encode as Encode exposing (Value)
import Mousikea.Examples as Example
import Mousikea.Midi.Encoder as Encoder
import Mousikea.Midi.MEvent as Perf exposing (MEvent, Performance)



---- PORTS ----


port play : Value -> Cmd msg



---- MODEL ----


type alias Model =
    Performance


init : ( Model, Cmd Msg )
init =
    ( Example.childSong6 |> Perf.performPitch, Cmd.none )



---- UPDATE ----


type Msg
    = Play


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play ->
            ( model, play (Encode.list Encoder.mEvent model) )



---- VIEW ----


view : Model -> Html Msg
view _ =
    Html.div []
        [ Html.button [ Html.Events.onClick Play ] [ Html.text "Play!" ] ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
