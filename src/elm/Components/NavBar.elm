module Components.NavBar exposing (Config, Msg(..), defaultModel, navBar, navMenu, update)

import Auth.LogIn as LogIn exposing (logInForm)
import Auth.SignUp as SignUp exposing (signUpForm)
import Auth.User exposing (User, initialUser)
import Components.Btn exposing (btnProps, defaultBtn)
import Components.Layout exposing (styles)
import Html exposing (Html, div, span, text)
import Html.Events
import Material.Drawer exposing (drawerContent, drawerScrim, modalDrawer, modalDrawerConfig)
import Material.Icon exposing (icon, iconConfig)
import Material.LayoutGrid exposing (layoutGrid, layoutGridCell, layoutGridInner, span1Phone, span2Phone, span2Tablet, span3Desktop, span4Tablet, span6Desktop, span6Tablet)
import Material.Menu exposing (menu, menuConfig, menuSurfaceAnchor)
import Material.TopAppBar as TopAppBar exposing (alignEnd, alignStart, navigationIcon, prominentTopAppBar, topAppBarConfig)


type alias Config msg =
    { user : User
    , open : Bool
    , signUpOpen : Bool
    , logInOpen : Bool
    , userInfoOpen : Bool
    , maybeTitle : Maybe String
    , maybeTabs : Maybe (List (Html msg))
    , actions : List (Html msg)
    , onClose : Maybe msg
    }


defaultModel : Config msg
defaultModel =
    { user = initialUser
    , open = False
    , signUpOpen = False
    , logInOpen = False
    , userInfoOpen = False
    , maybeTitle = Nothing
    , maybeTabs = Nothing
    , actions = []
    , onClose = Nothing
    }


type Msg
    = OpenMenu
    | CloseMenu
    | OpenSignUp
    | CloseSignUp
    | OpenLogIn
    | CloseLogIn
    | OpenUserInfo
    | CloseUserInfo
    | SignUpMsg SignUp.Msg
    | LoginMsg LogIn.Msg


update : Msg -> Config msg -> ( Config msg, Cmd msg )
update msg model =
    case ( msg, model.user ) of
        ( OpenMenu, _ ) ->
            ( { model
                | open = True
              }
            , Cmd.none
            )

        ( CloseMenu, _ ) ->
            ( { model
                | open = False
              }
            , Cmd.none
            )

        ( OpenSignUp, _ ) ->
            ( { model
                | signUpOpen = True
              }
            , Cmd.none
            )

        ( CloseSignUp, _ ) ->
            ( { model
                | signUpOpen = False
              }
            , Cmd.none
            )

        ( OpenLogIn, _ ) ->
            ( { model
                | logInOpen = True
              }
            , Cmd.none
            )

        ( CloseLogIn, _ ) ->
            ( { model
                | logInOpen = False
              }
            , Cmd.none
            )

        ( OpenUserInfo, _ ) ->
            ( { model
                | userInfoOpen = True
              }
            , Cmd.none
            )

        ( CloseUserInfo, _ ) ->
            ( { model
                | userInfoOpen = False
              }
            , Cmd.none
            )

        ( SignUpMsg signUp, user ) ->
            let
                ( updatedUser, signUpCmd ) =
                    SignUp.update signUp user
            in
            ( { model
                | user = updatedUser
              }
            , Cmd.map SignUpMsg signUpCmd
            )

        ( LoginMsg logIn, user ) ->
            let
                ( updatedUser, loginCmd ) =
                    LogIn.update logIn user
            in
            ( { model
                | user = updatedUser
              }
            , Cmd.map LoginMsg loginCmd
            )


navBar : Config msg -> Html msg
navBar config =
    let
        titleView content =
            span [ TopAppBar.title ]
                [ text content
                ]

        title =
            case config.maybeTitle of
                Just value ->
                    TopAppBar.row []
                        [ TopAppBar.section []
                            [ titleView value
                            ]
                        ]

                Nothing ->
                    TopAppBar.row [] []

        mobileTitle =
            case config.maybeTitle of
                Just content ->
                    titleView content

                Nothing ->
                    span [] []

        tabs =
            case config.maybeTabs of
                Just content ->
                    TopAppBar.section [] content

                Nothing ->
                    TopAppBar.section [] []

        toggleMenu =
            if config.open then
                CloseMenu

            else
                OpenMenu

        menuButtonSection =
            TopAppBar.section [ alignStart ]
                [ icon
                    { iconConfig
                        | additionalAttributes =
                            [ navigationIcon
                            , Html.Events.onClick toggleMenu
                            ]
                    }
                    "menu"
                ]
    in
    div []
        [ layoutGridCell styles.notOnMobile
            [ prominentTopAppBar { topAppBarConfig | fixed = True }
                [ title
                , TopAppBar.row []
                    [ menuButtonSection
                    , tabs
                    , TopAppBar.section [ alignEnd ] config.actions
                    ]
                ]
            ]
        , layoutGridCell styles.onMobileOnly
            [ TopAppBar.shortTopAppBar topAppBarConfig
                [ TopAppBar.row []
                    [ menuButtonSection
                    , mobileTitle
                    , TopAppBar.section [ alignEnd ] config.actions
                    ]
                ]
            ]
        ]


navMenu : Config msg -> Html msg -> Html msg
navMenu config content =
    layoutGrid []
        [ layoutGridInner []
            [ layoutGridCell []
                [ modalDrawer
                    { modalDrawerConfig
                        | open = config.open
                        , onClose = config.onClose
                    }
                    [ drawerContent [] [] ]
                , drawerScrim [] []
                , content
                ]
            ]
        ]


defaultActions : Config msg -> Html Msg
defaultActions config =
    layoutGrid
        [ span6Desktop
        , span4Tablet
        , span2Phone
        ]
        [ layoutGridInner [ menuSurfaceAnchor ]
            [ layoutGridCell
                [ span3Desktop
                , span2Tablet
                , span1Phone
                ]
                [ defaultBtn
                    { btnProps
                        | label = "Sign up"
                        , icon = Just "person_add"
                        , clickHandler = Just OpenSignUp
                    }
                ]
            , layoutGridCell
                [ span3Desktop
                , span2Tablet
                , span1Phone
                ]
                [ defaultBtn
                    { btnProps
                        | label = "Log in"
                        , icon = Just "person"
                        , clickHandler = Just OpenLogIn
                    }
                ]
            , layoutGridCell
                [ span6Desktop
                , span4Tablet
                , span2Phone
                ]
                [ menu
                    { menuConfig
                        | open = config.signUpOpen
                        , onClose = Just CloseSignUp
                    }
                    [ layoutGrid [] [ signUpForm config.user |> Html.map SignUpMsg ]
                    ]
                , menu
                    { menuConfig
                        | open = config.logInOpen
                        , onClose = Just CloseLogIn
                    }
                    [ layoutGrid [] [ logInForm config.user |> Html.map LoginMsg ] ]
                ]
            ]
        ]
