module Loading exposing (Model, Msg, init, subscriptions, update, view)

import Browser exposing (Document)
import Browser.Dom exposing (Viewport)
import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Html, div, text)
import Task


type alias Model =
    Maybe Viewport


type Msg
    = Tick Float
    | Viewport Viewport


init : () -> ( Model, Cmd Msg )
init flags =
    ( Nothing
    , Task.perform Viewport Browser.Dom.getViewport
    )


view : Model -> Document Msg
view model =
    { title = "Loading"
    , body =
        [ text (viewportText model)
        ]
    }


viewportText : Maybe Viewport -> String
viewportText mv =
    case mv of
        Just viewport ->
            String.fromFloat viewport.viewport.width ++ " x " ++ String.fromFloat viewport.viewport.height

        Nothing ->
            "Nothing"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ms ->
            ( model, Cmd.none )

        Viewport viewport ->
            ( Just viewport
            , Task.perform Viewport Browser.Dom.getViewport
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    onAnimationFrameDelta Tick
