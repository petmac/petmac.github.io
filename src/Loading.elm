module Loading exposing (Model, Msg, init, subscriptions, update, view)

import Browser exposing (Document)
import Browser.Events exposing (onAnimationFrameDelta)
import Css exposing (..)
import Html.Styled exposing (Html, div, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Random
import Task


type alias Bar =
    { top : Float
    , height : Float
    , color : Color
    }


type alias Model =
    { bars : Maybe (List Bar)
    }


type Msg
    = Tick Float
    | Bars (List Bar)


init : () -> ( Model, Cmd Msg )
init flags =
    ( { bars = Nothing }
    , Cmd.batch [ generateBars ]
    )


generateBars : Cmd Msg
generateBars =
    Random.generate Bars barsGenerator


barsGenerator : Random.Generator (List Bar)
barsGenerator =
    Random.list 1 barGenerator


barGenerator : Random.Generator Bar
barGenerator =
    Random.map2
        (\h col -> { top = 0, height = h, color = col })
        (Random.float 5 10)
        colorGenerator


colorGenerator : Random.Generator Color
colorGenerator =
    Random.uniform (hex "ff0000") [ hex "00ff00", hex "0000ff" ]


view : Model -> Document Msg
view model =
    { title = "Loading"
    , body =
        case model.bars of
            Just bars ->
                List.map viewBar bars
                    |> List.map toUnstyled

            Nothing ->
                []
    }


viewBar : Bar -> Html Msg
viewBar bar =
    div
        [ css
            [ position absolute
            , left (pct 0)
            , top (pct bar.top)
            , width (pct 100)
            , height (pct bar.height)
            , backgroundColor bar.color
            ]
        ]
        []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ms ->
            ( model
            , Cmd.batch [ generateBars ]
            )

        Bars bars ->
            ( { model | bars = Just bars }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    onAnimationFrameDelta Tick
