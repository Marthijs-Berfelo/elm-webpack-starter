module Components.Input exposing (passwordInput, textInput)

import Html exposing (Attribute, Html, div)
import Material.HelperText exposing (characterCounter, helperLine, helperText, helperTextConfig)
import Material.Icon exposing (IconConfig)
import Material.TextField exposing (TextFieldConfig, textField, textFieldConfig, textFieldIcon)


type alias FieldProps msg =
    { value : Maybe String
    , label : String
    , placeholder : String
    , icon : Maybe (IconProps msg)
    , disabled : Bool
    , required : Bool
    , invalid : Bool
    , hintText : Maybe String
    , maxLength : Maybe Int
    , customStyles : List (Attribute msg)
    }


type alias IconProps msg =
    { icon : String
    , config : IconConfig msg
    }


passwordInput : FieldProps msg -> Html msg
passwordInput props =
    let
        field =
            [ textField <| fieldConfig "password" props ]

        hints =
            fieldHints props

        fields =
            case List.isEmpty hints of
                True ->
                    field

                False ->
                    List.append field <| [ helperLine [] hints ]
    in
    div []
        fields


textInput : FieldProps msg -> Html msg
textInput props =
    let
        field =
            [ textField <| fieldConfig "text" props ]

        hints =
            fieldHints props

        fields =
            case List.isEmpty hints of
                True ->
                    field

                False ->
                    List.append field <| [ helperLine [] hints ]
    in
    div []
        fields


fieldConfig : String -> FieldProps msg -> TextFieldConfig msg
fieldConfig fieldType props =
    let
        config =
            { textFieldConfig
                | type_ = fieldType
                , outlined = True
                , invalid = props.invalid
                , disabled = props.disabled
                , required = props.required
                , label = Just props.label
                , value = props.value
                , placeholder = Just props.placeholder
                , maxLength = props.maxLength
                , additionalAttributes = props.customStyles
            }
    in
    case props.icon of
        Just iconConf ->
            { config
                | leadingIcon = textFieldIcon iconConf.config iconConf.icon
            }

        Nothing ->
            config


fieldHints : FieldProps msg -> List (Html msg)
fieldHints props =
    let
        counter =
            case props.maxLength of
                Just _ ->
                    [ characterCounter [] ]

                Nothing ->
                    []
    in
    case props.hintText of
        Just text ->
            List.append [ helperText { helperTextConfig | persistent = True } text ] counter

        Nothing ->
            counter
