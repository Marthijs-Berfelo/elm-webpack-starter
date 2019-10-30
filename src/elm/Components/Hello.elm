module Components.Hello exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Card exposing (CardBlock, cardBlock)
import Material.Typography as Typography
import String



-- hello component


hello : Int -> CardBlock a
hello model =
    cardBlock <|
        div
            [ Typography.headline3, style "margin-top" "20px", style "margin-bottom" "10px" ]
            [ text ("Hello, Elm" ++ ("!" |> String.repeat model)) ]
