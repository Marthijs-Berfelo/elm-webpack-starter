module Components.Input exposing (AreaProps, TextProps, areaInput, passwordInput, textInput)

import Components exposing (IconProps, InputProps)
import Html exposing (Attribute, Html)
import Material.HelperText exposing (characterCounter, helperLine, helperText, helperTextConfig)
import Material.LayoutGrid exposing (layoutGridCell)
import Material.TextArea exposing (TextAreaConfig, textArea, textAreaConfig)
import Material.TextField exposing (TextFieldConfig, textField, textFieldConfig, textFieldIcon)


type alias TextProps msg =
    InputProps
        { icon : Maybe (IconProps msg)
        }
        msg


type alias AreaProps msg =
    InputProps
        { rows : Maybe Int
        , cols : Maybe Int
        }
        msg


passwordInput : TextProps msg -> Html msg
passwordInput props =
    let
        field =
            [ textField <| fieldConfig "password" props ]

        hints =
            fieldHints props.maxLength props.hintText

        fields =
            case List.isEmpty hints of
                True ->
                    field

                False ->
                    List.append field <| [ helperLine [] hints ]
    in
    inputField
        props.responsive
        fields


textInput : TextProps msg -> Html msg
textInput props =
    let
        field =
            [ textField <| fieldConfig "text" props ]

        hints =
            fieldHints props.maxLength props.hintText

        fields =
            case List.isEmpty hints of
                True ->
                    field

                False ->
                    List.append field <| [ helperLine [] hints ]
    in
    inputField
        props.responsive
        fields


areaInput : AreaProps msg -> Html msg
areaInput props =
    let
        area =
            [ textArea <| areaConfig props ]

        hints =
            fieldHints props.maxLength props.hintText

        fields =
            case List.isEmpty hints of
                True ->
                    area

                False ->
                    List.append area <| [ helperLine [] hints ]
    in
    inputField
        props.responsive
        fields


fieldConfig : String -> TextProps msg -> TextFieldConfig msg
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
                , onChange = props.changeHandler
            }
    in
    case props.icon of
        Just iconConf ->
            { config
                | leadingIcon = textFieldIcon iconConf.config iconConf.icon
            }

        Nothing ->
            config


areaConfig : AreaProps msg -> TextAreaConfig msg
areaConfig props =
    { textAreaConfig
        | outlined = True
        , fullwidth = True
        , invalid = props.invalid
        , disabled = props.disabled
        , required = props.required
        , label = Just props.label
        , value = props.value
        , placeholder = Just props.placeholder
        , rows = props.rows
        , cols = props.cols
        , maxLength = props.maxLength
        , additionalAttributes = props.customStyles
        , onChange = props.changeHandler
    }


fieldHints : Maybe Int -> Maybe String -> List (Html msg)
fieldHints maxLength hintText =
    let
        counter =
            case maxLength of
                Just _ ->
                    [ characterCounter [] ]

                Nothing ->
                    []
    in
    case hintText of
        Just text ->
            List.append [ helperText { helperTextConfig | persistent = True } text ] counter

        Nothing ->
            counter


inputField : List (Attribute msg) -> List (Html msg) -> Html msg
inputField responsive elements =
    layoutGridCell
        responsive
        elements
