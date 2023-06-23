module Content exposing (PostContent, posts)


type alias PostContent =
    { title : String, name : String }


posts : List PostContent
posts =
    [ { title = "What is programming?", name = "what-is-programming" }
    , { title = "OOP", name = "oop" }
    , { title = "The SOLID principles", name = "solid" }
    , { title = "Strong and weak object references", name = "strong-and-weak-object-refs" }
    , { title = "Removing reference cycles", name = "removing-ref-cycles" }
    , { title = "Object equality", name = "object-equality" }
    ]
