module Page exposing (Page(..))

import PostPage exposing (PostPage)


type Page
    = PostPage PostPage
    | NotFoundPage String
