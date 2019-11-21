module Auth.LogIn exposing (..)

import Auth.User exposing (User)
import Components exposing (defaultForm)
import Components.Btn exposing (btnProps, defaultBtn)
import Components.Input exposing (passwordInput, textInput, textProps)
import Html exposing (Html)
import Material.LayoutGrid exposing (layoutGridCell, span12)


type Msg
    = SaveEmail String
    | SavePassword String
    | Login


update : Msg -> User -> ( User, Cmd msg )
update message user =
    case message of
        SaveEmail email ->
            ( { user
                | email = email
              }
            , Cmd.none
            )

        SavePassword password ->
            ( { user
                | password = password
              }
            , Cmd.none
            )

        Login ->
            ( { user
                | loggedIn = True
              }
            , Cmd.none
            )


logInForm : User -> Html Msg
logInForm user =
    defaultForm []
        ""
        []
        [ textInput
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
                , changeHandler = Just SavePassword
            }
        , layoutGridCell [ span12 ]
            [ defaultBtn
                { btnProps
                    | label = "Log in"
                    , icon = Just "check"
                    , clickHandler = Just Login
                }
            ]
        ]
