module Page exposing (Page(..))

import PostPage exposing (PostPage)


type Page msg
    = PostPage (PostPage msg)
    | NotFoundPage String
