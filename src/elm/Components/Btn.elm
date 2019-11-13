module Components.Btn exposing (..)

import Components exposing (ComponentProps, IconProps)


type alias BtnProps msg =
    ComponentProps
        { icon : Maybe (IconProps msg)
        }
        msg
