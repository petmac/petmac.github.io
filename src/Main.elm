module Main exposing (Model, Msg(..), main)

import Browser
import Browser.Navigation as Nav
import Content exposing (PostContent, posts)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page exposing (Page(..))
import PostPage exposing (PostPage)
import Routing exposing (Route(..), routeForUrl)
import Url exposing (Url)



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
    , page : Page Msg
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( page, cmd ) =
            pageForUrl url
    in
    ( Model key page, cmd )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotPost (Result Http.Error String)


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
            let
                ( page, cmd ) =
                    pageForUrl url
            in
            ( { model | page = page }
            , cmd
            )

        GotPost result ->
            ( { model | page = PostPage (PostPage.build result) }, Cmd.none )


pageForUrl : Url -> ( Page Msg, Cmd Msg )
pageForUrl url =
    case routeForUrl url of
        Post name ->
            let
                ( postPage, cmd ) =
                    PostPage.load GotPost name
            in
            ( PostPage postPage, cmd )

        NotFound path ->
            ( NotFoundPage path, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Peter Mackay"
    , body = body model.page
    }


body : Page Msg -> List (Html Msg)
body page =
    case page of
        PostPage pp ->
            PostPage.body pp

        NotFoundPage path ->
            [ text path
            , ul [] (List.map postLink posts)
            ]


postLink : PostContent -> Html Msg
postLink content =
    li [] [ a [ href ("/posts/" ++ content.name) ] [ text content.title ] ]
