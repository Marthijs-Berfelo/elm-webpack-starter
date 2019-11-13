module Components exposing (..)

import Html exposing (Attribute)
import Material.Icon exposing (IconConfig)


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
