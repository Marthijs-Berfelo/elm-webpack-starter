module Main exposing (init, main, update, view)

-- component import example

import Browser
import Components.Hello exposing (hello)
import Html exposing (Attribute, Html, p, text)
import Html.Attributes exposing (..)
import Material.Button exposing (buttonConfig, raisedButton)
import Material.Card as Card exposing (CardBlock, card, cardBlock, cardConfig, cardMedia, cardMediaConfig)
import Material.LayoutGrid exposing (alignMiddle, layoutGrid, layoutGridCell, layoutGridInner, span3, span4Phone, span6Desktop, span8Tablet)
import Material.Theme as Theme
import Material.Typography as Typography



-- APP


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = NoOp
    | Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Increment ->
            model + 1



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    layoutGrid
        [ alignMiddle
        , style "text-align" "center"
        , style "align-items" "center"
        , style "margin" "auto"
        ]
        [ layoutGridInner []
            [ layoutGridCell [ span3 ] []
            , layoutGridCell [ span6Desktop, span8Tablet, span4Phone ]
                [ card
                    { cardConfig
                        | additionalAttributes =
                            [ Theme.onSurface
                            , style "background-color" "#eeeeee"
                            , style "padding" "48px 60px"
                            ]
                    }
                    { blocks =
                        [ image
                        , hello model
                        , body
                        , bodyButton
                        ]
                    , actions = Nothing
                    }
                ]
            , layoutGridCell [ span3 ] []
            ]
        ]


image : CardBlock msg
image =
    cardMedia
        { cardMediaConfig
            | aspect = Just Card.Square
            , additionalAttributes =
                styles.img
        }
        "static/img/elm.jpg"


body : CardBlock msg
body =
    cardBlock <|
        p [ Typography.body1 ]
            [ text "Elm Webpack Starter" ]


bodyButton : CardBlock Msg
bodyButton =
    cardBlock <|
        raisedButton
            { buttonConfig
                | icon = Just "star"
                , onClick = Just Increment
                , additionalAttributes =
                    [ style "text-align" "center"
                    , style "margin" "auto"
                    ]
            }
            "FTW!"



-- CSS STYLES


styles : { img : List (Attribute msg) }
styles =
    { img =
        [ style "width" "33%"
        , style "min-width" "120px"
        , style "border" "4px solid #337AB7"
        , style "margin" "auto"
        ]
    }
