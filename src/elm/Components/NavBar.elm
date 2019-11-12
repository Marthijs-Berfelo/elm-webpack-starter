module Components.NavBar exposing (Config, Msg(..), defaultModel, navBar, navMenu, update)

import Components.Layout exposing (styles)
import Html exposing (Html, div, span, text)
import Html.Events
import Material.Drawer exposing (drawerContent, drawerScrim, modalDrawer, modalDrawerConfig)
import Material.Icon exposing (icon, iconConfig)
import Material.LayoutGrid exposing (layoutGridCell)
import Material.TopAppBar as TopAppBar exposing (alignEnd, alignStart, navigationIcon, prominentTopAppBar, topAppBarConfig)


type alias Config msg =
    { open : Bool
    , maybeTitle : Maybe String
    , maybeTabs : Maybe (List (Html msg))
    , actions : List (Html msg)
    , onClose : Maybe msg
    }


defaultModel : Config msg
defaultModel =
    { open = False
    , maybeTitle = Nothing
    , maybeTabs = Nothing
    , actions = []
    , onClose = Nothing
    }


type Msg
    = OpenMenu
    | CloseMenu


update : Msg -> Config msg -> Config msg
update msg model =
    case msg of
        OpenMenu ->
            { model | open = True }

        CloseMenu ->
            { model | open = False }


navBar : Config msg -> Html msg
navBar config =
    let
        titleView content =
            span [ TopAppBar.title ]
                [ text content
                ]

        title =
            case config.maybeTitle of
                Just content ->
                    TopAppBar.row []
                        [ TopAppBar.section []
                            [ titleView content
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
    layoutGridCell []
        [ modalDrawer
            { modalDrawerConfig
                | open = config.open
                , onClose = config.onClose
            }
            [ drawerContent [] [] ]
        , drawerScrim [] []
        , content
        ]
