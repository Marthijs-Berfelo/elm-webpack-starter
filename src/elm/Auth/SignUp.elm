module Auth.SignUp exposing (..)

import Auth.User exposing (User)
import Components exposing (defaultForm)
import Components.Btn exposing (btnProps, defaultBtn)
import Components.Input exposing (passwordInput, textInput, textProps)
import Html exposing (Html)
import Material.LayoutGrid exposing (layoutGridCell, span12)


type Msg
    = SaveName String
    | SaveEmail String
    | SavePassword String
    | SignUp


update : Msg -> User -> ( User, Cmd msg )
update message user =
    case message of
        SaveName name ->
            ( { user
                | name = name
              }
            , Cmd.none
            )

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

        SignUp ->
            ( { user
                | loggedIn = True
              }
            , Cmd.none
            )


signUpForm : User -> Html Msg
signUpForm user =
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
                , changeHandler = Just SavePassword
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
