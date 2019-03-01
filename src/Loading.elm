module Loading exposing (Model, Msg, init, subscriptions, update, view)

import Browser exposing (Document)
import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Html, div, text)


type alias Model =
    Float


type Msg
    = Tick Float


init : () -> ( Model, Cmd Msg )
init flags =
    ( 0, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Loading"
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
