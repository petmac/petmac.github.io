module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html)
import Loading


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Model
    = LoadingModel Loading.Model


type Msg
    = LoadingMsg Loading.Msg


init : () -> ( Model, Cmd Msg )
init flags =
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


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        LoadingModel lmodel ->
            Loading.subscriptions lmodel |> Sub.map LoadingMsg
