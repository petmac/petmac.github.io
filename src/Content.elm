module Content exposing (PostContent, posts)


type alias PostContent =
    { title : String, name : String }


posts : List PostContent
posts =
    [ { title = "What is programming?", name = "what-is-programming" }
    , { title = "OOP", name = "oop" }
    , { title = "SOLID", name = "solid" }
    , { title = "Object equality", name = "object-equality" }
    , { title = "Strong and weak object references", name = "strong-and-weak-object-refs" }
    , { title = "Removing Reference Cycles", name = "removing-ref-cycles" }
    ]
