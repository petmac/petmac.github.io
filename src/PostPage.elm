module PostPage exposing (PostPage(..), body, build, load)

import Html exposing (..)
import Http


type PostPage
    = Loading
    | Loaded String
    | Error String


load : (Result Http.Error String -> msg) -> String -> ( PostPage, Cmd msg )
load makeMsg name =
    ( Loading, getPost makeMsg name )


build : Result Http.Error String -> PostPage
build result =
    case result of
        Ok data ->
            Loaded data

        Err _ ->
            Error "Some error"


body : PostPage -> List (Html cmd)
body page =
    case page of
        Loading ->
            [ text "Post" ]

        Loaded loaded ->
            [ text loaded ]

        Error _ ->
            [ text "Error" ]


getPost : (Result Http.Error String -> msg) -> String -> Cmd msg
getPost makeMsg name =
    Http.get
        { url = "/content/posts/" ++ name ++ ".txt"
        , expect = Http.expectString makeMsg
        }
