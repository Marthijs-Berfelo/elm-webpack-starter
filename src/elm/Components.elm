module Components exposing (..)

import Html exposing (Attribute, Html, form, span, text)
import Material.Icon exposing (IconConfig)
import Material.LayoutGrid exposing (layoutGridInner)
import Material.Typography exposing (headline3)


type alias ComponentProps p msg =
    { p
        | label : String
        , value : Maybe String
        , disabled : Bool
        , responsive : List (Attribute msg)
        , customStyles : List (Attribute msg)
        , clickHandler : Maybe msg
    }


type alias InputProps p msg =
    ComponentProps
        { p
            | placeholder : String
            , required : Bool
            , invalid : Bool
            , hintText : Maybe String
            , maxLength : Maybe Int
            , changeHandler : Maybe (String -> msg)
        }
        msg


type alias IconProps msg =
    { icon : String
    , config : IconConfig msg
    }


defaultForm : List (Attribute msg) -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
defaultForm layoutAttributes formTitle formAttributes children =
    layoutGridInner layoutAttributes
        [ span [ headline3 ] [ text formTitle ]
        , form formAttributes children
        ]
