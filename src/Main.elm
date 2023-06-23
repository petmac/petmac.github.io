module Main exposing (Model, Msg(..), main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Routing exposing (Route(..), routeForUrl, routePath)
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , route : Route
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key (routeForUrl url), Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = routeForUrl url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Peter Mackay"
    , body =
        [ text "The current page is: "
        , b [] [ text (Routing.toString model.route) ]
        , ul [] (List.map viewLink postLinks)
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


postLinks : List String
postLinks =
    List.filterMap routePath postRoutes


postRoutes : List Route
postRoutes =
    List.map Post postNames


postNames : List String
postNames =
    [ "object-equality"
    , "oop"
    , "removing-ref-cycles"
    , "solid"
    , "strong-and-weak-object-refs"
    , "what-is-programming"
    ]
