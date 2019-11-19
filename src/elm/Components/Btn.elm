module Components.Btn exposing (BtnProps, btnProps, defaultBtn, outlinedBtn)

import Components exposing (ComponentProps, IconProps)
import Html exposing (Html)
import Material.Button exposing (ButtonConfig, buttonConfig, outlinedButton, raisedButton)


type alias BtnProps msg =
    ComponentProps
        { icon : Maybe String
        }
        msg


btnProps : BtnProps msg
btnProps =
    { label = ""
    , value = Nothing
    , icon = Nothing
    , disabled = False
    , responsive = []
    , customStyles = []
    , clickHandler = Nothing
    }


defaultBtn : BtnProps msg -> Html msg
defaultBtn props =
    (btnConfig props |> raisedButton) props.label


outlinedBtn : BtnProps msg -> Html msg
outlinedBtn props =
    (btnConfig props |> outlinedButton) props.label


btnConfig : BtnProps msg -> ButtonConfig msg
btnConfig props =
    { buttonConfig
        | icon = props.icon
        , trailingIcon = False
        , disabled = props.disabled
        , dense = False
        , additionalAttributes = props.customStyles
        , onClick = props.clickHandler
    }
