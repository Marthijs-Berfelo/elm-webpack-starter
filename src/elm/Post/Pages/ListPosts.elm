module Post.Pages.ListPosts exposing (Model, Msg, init, update, view)

import Error exposing (buildErrorMessage, viewError, viewMaybeError)
import Html exposing (Html, a, br, button, div, h3, table, td, text, th, tr)
import Html.Attributes exposing (href, type_)
import Html.Events exposing (onClick)
import Http exposing (Expect)
import Post exposing (Post, PostId, postsDecoder)
import Post.Client exposing (deletePost, fetchPosts)
import RemoteData exposing (WebData)


type alias Model =
    { posts : WebData (List Post)
    , deleteError : Maybe String
    }


type Msg
    = FetchPosts
    | PostsReceived (WebData (List Post))
    | DeletePost PostId
    | PostDeleted (Result Http.Error String)


init : ( Model, Cmd Msg )
init =
    ( { posts = RemoteData.Loading
      , deleteError = Nothing
      }
    , fetchPosts <|
        Http.expectJson (RemoteData.fromResult >> PostsReceived) <|
            postsDecoder
    )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchPosts ]
            [ text "Refresh posts" ]
        , br [] []
        , br [] []
        , a [ href "/posts/new" ]
            [ text "Create new post" ]
        , viewPosts model
        , viewMaybeError "delete post" model.deleteError
        ]


viewPosts : Model -> Html Msg
viewPosts model =
    case model.posts of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading ..." ]

        RemoteData.Success actualPosts ->
            div []
                [ h3 [] [ text "Posts" ]
                , table []
                    ([ viewTableHeader ] ++ List.map viewPost actualPosts)
                ]

        RemoteData.Failure httpError ->
            viewError "fetch data" (buildErrorMessage httpError)


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Title" ]
        , th []
            [ text "Author" ]
        ]


viewPost : Post -> Html Msg
viewPost post =
    let
        postPath =
            "/posts/" ++ Post.idToString post.id
    in
    tr []
        [ td []
            [ text (Post.idToString post.id) ]
        , td []
            [ text post.title ]
        , td []
            [ a [ href post.authorUrl ] [ text post.authorName ] ]
        , td []
            [ a [ href postPath ] [ text "Edit" ] ]
        , td []
            [ button [ type_ "button", onClick (DeletePost post.id) ]
                [ text "Delete" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPosts ->
            ( { model | posts = RemoteData.Loading }
            , fetchPosts <|
                Http.expectJson (RemoteData.fromResult >> PostsReceived) <|
                    postsDecoder
            )

        PostsReceived response ->
            ( { model | posts = response }, Cmd.none )

        DeletePost postId ->
            ( model
            , deletePost postId <|
                Http.expectString PostDeleted
            )

        PostDeleted (Ok _) ->
            ( model
            , fetchPosts <|
                Http.expectJson (RemoteData.fromResult >> PostsReceived) <|
                    postsDecoder
            )

        PostDeleted (Err error) ->
            ( { model | deleteError = Just (buildErrorMessage error) }
            , Cmd.none
            )
