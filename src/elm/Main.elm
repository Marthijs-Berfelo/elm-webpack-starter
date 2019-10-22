module Main exposing (..)

-- component import example

import Browser
import Components.Hello exposing (hello)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



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
    div [ class "container", style "margin-top" "30px", style "text-align" "center" ]
        [ -- inline CSS (literal)
          div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "jumbotron" ]
                    [ img (src "static/img/elm.jpg" :: styles.img) [] -- inline CSS (via var)
                    , hello model -- ext 'hello' component (takes 'model' as arg)
                    , p [] [ text "Elm Webpack Starter" ]
                    , button [ class "btn btn-primary btn-lg", onClick Increment ]
                        [ -- click handler
                          span [ class "glyphicon glyphicon-star" ] [] -- glyphicon
                        , span [] [ text "FTW!" ]
                        ]
                    ]
                ]
            ]
        ]



-- CSS STYLES


styles : { img : List (Attribute msg) }
styles =
    { img =
        [ style "width" "33%"
        , style "border" "4px solid #337AB7"
        ]
    }
