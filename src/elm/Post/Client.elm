module Post.Client exposing (..)

import Http exposing (Expect)
import Post exposing (Post, PostId, newPostEncoder, postEncoder)
import RemoteData exposing (WebData)


postsEndpoint : String
postsEndpoint =
    "/posts"


postIdEndpoint : PostId -> String
postIdEndpoint postId =
    postsEndpoint ++ Post.idToString postId


createPost : WebData Post -> Expect msg -> Cmd msg
createPost post expect =
    case post of
        RemoteData.Success postData ->
            Http.request
                { method = "POST"
                , headers = []
                , url = postsEndpoint
                , body = Http.jsonBody (newPostEncoder postData)
                , expect = expect
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none


fetchPost : PostId -> Expect msg -> Cmd msg
fetchPost postId expect =
    Http.request
        { method = "GET"
        , headers = []
        , url = postIdEndpoint postId
        , body = Http.emptyBody
        , expect = expect
        , timeout = Nothing
        , tracker = Nothing
        }


savePost : WebData Post -> Expect msg -> Cmd msg
savePost post expect =
    case post of
        RemoteData.Success postData ->
            let
                postUrl =
                    postIdEndpoint postData.id
            in
            Http.request
                { method = "PATCH"
                , headers = []
                , url = postUrl
                , body = Http.jsonBody (postEncoder postData)
                , expect = expect
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none


fetchPosts : Expect msg -> Cmd msg
fetchPosts expect =
    Http.get
        { url = postsEndpoint
        , expect = expect
        }


deletePost : PostId -> Expect msg -> Cmd msg
deletePost postId expect =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = postIdEndpoint postId
        , body = Http.emptyBody
        , expect = expect
        , timeout = Nothing
        , tracker = Nothing
        }
