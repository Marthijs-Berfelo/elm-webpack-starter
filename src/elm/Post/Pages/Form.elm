module Post.Pages.Form exposing (FormModel, Msg, initCreateMode, initEditMode, update, view)

import Browser.Navigation as Nav
import Components.Layout exposing (layout)
import Components.NavBar exposing (defaultModel, navBar)
import Error exposing (buildErrorMessage, viewError, viewMaybeError)
import Html exposing (Html, br, button, div, h3, input, span, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Material.LayoutGrid exposing (layoutGridCell)
import Material.Typography exposing (headline3)
import Navigation.Route as Route
import Post exposing (Post, PostId, emptyPost, postDecoder)
import Post.Client exposing (createPost, fetchPost, savePost)
import RemoteData exposing (RemoteData(..), WebData)


type alias FormModel =
    { navKey : Nav.Key
    , state : FormState
    , mode : String
    , onSubmit : Msg
    }


type alias FormState =
    { post : WebData Post
    , createError : Maybe String
    , editError : Maybe String
    }


type Msg
    = PostReceived (WebData Post)
    | UpdateTitle String
    | UpdateAuthorName String
    | UpdateAuthorUrl String
    | CreatePost
    | SavePost
    | PostCreated (Result Http.Error Post)
    | PostSaved (Result Http.Error Post)


initEditMode : PostId -> Nav.Key -> ( FormModel, Cmd Msg )
initEditMode postId navKey =
    ( initialModel navKey RemoteData.NotAsked RemoteData.Loading
    , postDecoder
        |> Http.expectJson (RemoteData.fromResult >> PostReceived)
        |> fetchPost postId
    )


initCreateMode : Nav.Key -> ( FormModel, Cmd Msg )
initCreateMode navKey =
    ( initialModel navKey (RemoteData.succeed emptyPost) RemoteData.NotAsked, Cmd.none )


view : FormModel -> Html Msg
view model =
    let
        state =
            model.state
    in
    layout (navBar defaultModel)
        (layoutGridCell []
            [ span [ headline3 ] [ text "Edit Post" ]
            , viewPost state.post model.onSubmit
            , viewMaybeError "save post" state.editError
            , viewMaybeError "create post" state.createError
            ]
        )
    <|
        Nothing


viewPost : WebData Post -> Msg -> Html Msg
viewPost post action =
    case post of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading Post..." ]

        RemoteData.Success postData ->
            editForm postData action

        RemoteData.Failure httpError ->
            viewError "fetch post" (buildErrorMessage httpError)


editForm : Post -> Msg -> Html Msg
editForm post action =
    Html.form []
        [ div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , value post.title
                , onInput UpdateTitle
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Name"
            , br [] []
            , input
                [ type_ "text"
                , value post.authorName
                , onInput UpdateAuthorName
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author URL"
            , br [] []
            , input
                [ type_ "text"
                , value post.authorUrl
                , onInput UpdateAuthorUrl
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick action ]
                [ text "Submit" ]
            ]
        ]


update : Msg -> FormModel -> ( FormModel, Cmd Msg )
update msg model =
    let
        modelState =
            model.state
    in
    case msg of
        PostReceived post ->
            ( { model | state = { modelState | post = post } }, Cmd.none )

        UpdateTitle newTitle ->
            let
                updateTitle =
                    RemoteData.map
                        (\postData ->
                            { postData | title = newTitle }
                        )
                        modelState.post
            in
            ( { model
                | state =
                    { modelState | post = updateTitle }
              }
            , Cmd.none
            )

        UpdateAuthorName newName ->
            let
                updateName =
                    RemoteData.map
                        (\postData ->
                            { postData | authorName = newName }
                        )
                        modelState.post
            in
            ( { model
                | state =
                    { modelState | post = updateName }
              }
            , Cmd.none
            )

        UpdateAuthorUrl newUrl ->
            let
                updateUrl =
                    RemoteData.map
                        (\postData ->
                            { postData | authorUrl = newUrl }
                        )
                        modelState.post
            in
            ( { model
                | state =
                    { modelState | post = updateUrl }
              }
            , Cmd.none
            )

        CreatePost ->
            ( model
            , createPost modelState.post <|
                Http.expectJson PostCreated <|
                    postDecoder
            )

        PostCreated (Ok postData) ->
            let
                post =
                    RemoteData.succeed postData
            in
            ( { model
                | state =
                    { modelState | post = post }
              }
            , Route.pushUrl Route.Posts model.navKey
            )

        PostCreated (Err error) ->
            ( { model
                | state =
                    { modelState
                        | createError =
                            Just (buildErrorMessage error)
                    }
              }
            , Cmd.none
            )

        SavePost ->
            ( model
            , savePost modelState.post <|
                Http.expectJson PostSaved postDecoder
            )

        PostSaved (Ok postData) ->
            let
                post =
                    RemoteData.succeed postData
            in
            ( { model
                | state =
                    { modelState | post = post }
              }
            , Route.pushUrl Route.Posts model.navKey
            )

        PostSaved (Err error) ->
            ( { model
                | state =
                    { modelState
                        | editError =
                            Just (buildErrorMessage error)
                    }
              }
            , Cmd.none
            )


initialModel : Nav.Key -> WebData Post -> WebData Post -> FormModel
initialModel navKey newPost existingPost =
    let
        result =
            case newPost of
                RemoteData.Success _ ->
                    { mode = "Create"
                    , onSubmit = CreatePost
                    , post = newPost
                    }

                _ ->
                    { mode = "Edit"
                    , onSubmit = SavePost
                    , post = existingPost
                    }
    in
    buildModel
        navKey
        result


buildModel : Nav.Key -> { mode : String, onSubmit : Msg, post : WebData Post } -> FormModel
buildModel navKey config =
    let
        state =
            FormState
                config.post
                Nothing
                Nothing
    in
    FormModel
        navKey
        state
        config.mode
        config.onSubmit
