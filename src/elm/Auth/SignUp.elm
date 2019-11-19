module SignUp exposing (..)

import Auth.User exposing (User, initialUser)
import Browser
import Components exposing (defaultForm)
import Components.Btn exposing (btnProps, defaultBtn)
import Components.Input exposing (passwordInput, textInput, textProps)
import Css exposing (backgroundColor, block, border, borderRadius, cm, color, display, fontSize, hex, margin2, marginTop, padding, padding2, paddingLeft, px, width)
import Html exposing (Html)
import Html.Styled as Styled exposing (div, h1, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (css, id, type_)
import Html.Styled.Events exposing (onClick, onInput)
import Material.LayoutGrid exposing (layoutGridCell, span12)


type Msg
    = SaveName String
    | SaveEmail String
    | SavePassword String
    | SignUp


update : Msg -> User -> User
update message user =
    case message of
        SaveName name ->
            { user | name = name }

        SaveEmail email ->
            { user | email = email }

        SavePassword password ->
            { user | password = password }

        SignUp ->
            { user | loggedIn = True }


view : User -> Styled.Html Msg
view user =
    div []
        [ h1 [ css [ paddingLeft (cm 3) ] ] [ text "Sign up" ]
        , styledForm []
            [ div []
                [ text "Name"
                , styledInput
                    [ id "name"
                    , type_ "text"
                    , onInput SaveName
                    ]
                    []
                ]
            , div []
                [ text "Email"
                , styledInput
                    [ id "email"
                    , type_ "text"
                    , onInput SaveEmail
                    ]
                    []
                ]
            , div []
                [ text "Password"
                , styledInput
                    [ id "password"
                    , type_ "password"
                    , onInput SavePassword
                    ]
                    []
                ]
            , div []
                [ styledButton
                    [ type_ "submit"
                    , onClick SignUp
                    ]
                    [ text "Create my account" ]
                ]
            ]
        ]


newView : User -> Html Msg
newView user =
    defaultForm []
        "Sign up"
        []
        [ textInput
            { textProps
                | label = "Name"
                , value = Just user.name
                , placeholder = "Name"
                , required = True
                , responsive = [ span12 ]
                , changeHandler = Just SaveName
            }
        , textInput
            { textProps
                | label = "Email"
                , value = Just user.email
                , placeholder = "Email"
                , required = True
                , responsive = [ span12 ]
                , changeHandler = Just SaveEmail
            }
        , passwordInput
            { textProps
                | label = "Password"
                , value = Just user.password
                , placeholder = "Password"
                , required = True
                , responsive = [ span12 ]
                , changeHandler = Just SaveEmail
            }
        , layoutGridCell [ span12 ]
            [ defaultBtn
                { btnProps
                    | label = "Create my account"
                    , icon = Just "check"
                    , clickHandler = Just SignUp
                }
            ]
        ]


styledForm : List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg
styledForm =
    styled Styled.form
        [ borderRadius (px 5)
        , backgroundColor (hex "#f2f2f2")
        , padding (px 20)
        , width (px 300)
        ]


styledInput : List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg
styledInput =
    styled Styled.input
        [ display block
        , width (px 260)
        , padding2 (px 12) (px 20)
        , margin2 (px 8) (px 0)
        , border (px 0)
        , borderRadius (px 4)
        ]


styledButton : List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg
styledButton =
    styled Styled.button
        [ width (px 300)
        , backgroundColor (hex "#397cd5")
        , color (hex "#fff")
        , padding2 (px 14) (px 20)
        , marginTop (px 10)
        , borderRadius (px 4)
        , fontSize (px 16)
        ]


main : Program () User Msg
main =
    Browser.sandbox
        { init = initialUser
        , view = view >> toUnstyled
        , update = update
        }
