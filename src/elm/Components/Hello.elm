module Components.Hello exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Card exposing (CardBlock, cardBlock)
import Material.Typography exposing (headline3)
import String



-- hello component


hello : Int -> CardBlock a
hello model =
    cardBlock <|
        div
            [ headline3, style "margin-top" "20px", style "margin-bottom" "10px" ]
            [ text ("Hello, Elm" ++ ("!" |> String.repeat model)) ]
