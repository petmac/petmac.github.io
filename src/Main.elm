module Main exposing (main)

import Browser exposing (Document)
import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Html, div, text)


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Float


type Msg
    = Tick Float


init : () -> ( Model, Cmd Msg )
init flags =
    ( 0, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "PetMac"
    , body =
        [ text (String.fromFloat model)
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ms ->
            ( ms, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    onAnimationFrameDelta Tick
