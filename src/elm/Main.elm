module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (Html, h3, text)
import Main.Msg exposing (Msg(..))
import Navigation.Route as Route exposing (Route)
import Post.Pages.Form as PostForm
import Post.Pages.ListPosts as ListPosts
import Url exposing (Url)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


type alias Flags =
    { baseUrl : String }


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    , baseUrl : String
    }


type Page
    = NotFoundPage
    | ListPage ListPosts.Model
    | PostFormPage PostForm.FormModel


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            , baseUrl = flags.baseUrl
            }
    in
    initPage ( model, Cmd.none )


initPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initPage ( model, existingCommands ) =
    let
        ( currentPage, mappedPageCommands ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Posts ->
                    let
                        ( pageModel, pageCmd ) =
                            ListPosts.init
                    in
                    ( ListPage pageModel, Cmd.map ListPageMsg pageCmd )

                Route.Post postId ->
                    let
                        ( pageModel, pageCmd ) =
                            PostForm.initEditMode postId model.navKey
                    in
                    ( PostFormPage pageModel, Cmd.map PostFormMsg pageCmd )

                Route.NewPost ->
                    let
                        ( pageModel, pageCmd ) =
                            PostForm.initCreateMode model.navKey
                    in
                    ( PostFormPage pageModel, Cmd.map PostFormMsg pageCmd )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCommands, mappedPageCommands ]
    )


view : Model -> Document Msg
view model =
    { title = "Post App"
    , body = [ viewPage model ]
    }


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        NotFoundPage ->
            notFoundView

        ListPage pageModel ->
            ListPosts.view pageModel
                |> Html.map ListPageMsg

        PostFormPage pageModel ->
            PostForm.view pageModel
                |> Html.map PostFormMsg


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops, that page was not found!" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ListPageMsg subMsg, ListPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListPosts.update subMsg pageModel
            in
            ( { model | page = ListPage updatedPageModel }
            , Cmd.map ListPageMsg updatedCmd
            )

        ( PostFormMsg subMsg, PostFormPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    PostForm.update subMsg pageModel
            in
            ( { model | page = PostFormPage updatedPageModel }
            , Cmd.map PostFormMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initPage

        ( _, _ ) ->
            ( model, Cmd.none )
