module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key)
import Html
import Html.Styled exposing (Html)
import Loading
import Url exposing (Url)


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }


type Model
    = LoadingModel Loading.Model


type Msg
    = LoadingMsg Loading.Msg
    | Request UrlRequest
    | Url Url


init : () -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( loadingModel, loadingCmds ) =
            Loading.init flags
    in
    ( LoadingModel loadingModel, Cmd.map LoadingMsg loadingCmds )


view : Model -> Document Msg
view model =
    case model of
        LoadingModel lmodel ->
            let
                loadingDoc =
                    Loading.view lmodel
            in
            { title = loadingDoc.title
            , body = List.map (Html.map LoadingMsg) loadingDoc.body
            }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( LoadingMsg lmsg, LoadingModel lmodel ) ->
            let
                ( nextModel, lcmds ) =
                    Loading.update lmsg lmodel
            in
            ( LoadingModel nextModel
            , Cmd.map LoadingMsg lcmds
            )

        ( Request (Browser.External href), _ ) ->
            ( model, Browser.Navigation.load href )

        ( Request (Browser.Internal url), _ ) ->
            ( model, Cmd.none )

        ( Url _, _ ) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        LoadingModel lmodel ->
            Loading.subscriptions lmodel |> Sub.map LoadingMsg


onUrlRequest : UrlRequest -> Msg
onUrlRequest =
    Request


onUrlChange : Url -> Msg
onUrlChange =
    Url
