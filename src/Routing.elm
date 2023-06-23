module Routing exposing (Route(..), routeForUrl, routePath, toString)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string)


type Route
    = Post String
    | NotFound String


routeForUrl : Url -> Route
routeForUrl url =
    case parse routeParser url of
        Just route ->
            route

        Nothing ->
            NotFound url.path


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Post (s "posts" </> string)
        ]


routePath : Route -> Maybe String
routePath route =
    case route of
        Post name ->
            Just ("/posts/" ++ name)

        NotFound _ ->
            Nothing


toString : Route -> String
toString route =
    case route of
        Post name ->
            "Post " ++ name

        NotFound _ ->
            "Not Found"
