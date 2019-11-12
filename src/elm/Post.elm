module Post exposing
    ( Post
    , PostId
    , emptyPost
    , idParser
    , idToString
    , newPostEncoder
    , postDecoder
    , postEncoder
    , postsDecoder
    )

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, requiredAt)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)


type PostId
    = PostId Int


type alias Post =
    { id : PostId
    , title : String
    , authorName : String
    , authorUrl : String
    }


postsDecoder : Decoder (List Post)
postsDecoder =
    list postDecoder


postDecoder : Decoder Post
postDecoder =
    Decode.succeed Post
        |> required "id" idDecoder
        |> required "title" string
        |> requiredAt [ "author", "name" ] string
        |> requiredAt [ "author", "url" ] string


idDecoder : Decoder PostId
idDecoder =
    Decode.map PostId int


idToString : PostId -> String
idToString (PostId id) =
    String.fromInt id


idParser : Parser (PostId -> a) a
idParser =
    custom "POSTID" <|
        \postId ->
            Maybe.map PostId (String.toInt postId)


postEncoder : Post -> Encode.Value
postEncoder post =
    Encode.object
        [ ( "id", encodeId post.id )
        , ( "title", Encode.string post.title )
        , ( "author", encodeAuthor post )
        ]


newPostEncoder : Post -> Encode.Value
newPostEncoder post =
    Encode.object
        [ ( "title", Encode.string post.title )
        , ( "author", encodeAuthor post )
        ]


encodeId : PostId -> Encode.Value
encodeId (PostId id) =
    Encode.int id


encodeAuthor : Post -> Encode.Value
encodeAuthor post =
    Encode.object
        [ ( "name", Encode.string post.authorName )
        , ( "url", Encode.string post.authorUrl )
        ]


emptyPost : Post
emptyPost =
    { id = emptyPostId
    , title = ""
    , authorName = ""
    , authorUrl = ""
    }


emptyPostId : PostId
emptyPostId =
    PostId -1
