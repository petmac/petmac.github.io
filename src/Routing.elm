module Routing exposing (Route(..), routeForUrl)

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
