module PostPage exposing (PostPage(..), body, build, load)

import Html exposing (..)
import Http
import Markdown


type PostPage msg
    = Loading
    | Loaded (Html msg)
    | Error String


load : (Result Http.Error String -> msg) -> String -> ( PostPage msg, Cmd msg )
load makeMsg name =
    ( Loading, getPost makeMsg name )


build : Result Http.Error String -> PostPage msg
build result =
    case result of
        Ok markdown ->
            Loaded (Markdown.toHtml [] markdown)

        Err _ ->
            Error "Some error"


body : PostPage msg -> List (Html msg)
body page =
    case page of
        Loading ->
            [ text "Post" ]

        Loaded html ->
            [ html ]

        Error _ ->
            [ text "Error" ]


getPost : (Result Http.Error String -> msg) -> String -> Cmd msg
getPost makeMsg name =
    Http.get
        { url = "/content/posts/" ++ name ++ ".txt"
        , expect = Http.expectString makeMsg
        }
