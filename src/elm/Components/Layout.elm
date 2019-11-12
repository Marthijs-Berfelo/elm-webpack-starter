module Components.Layout exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (style)
import Material.LayoutGrid exposing (alignMiddle, layoutGrid, layoutGridCell, layoutGridInner)


layout : Html msg -> Html msg -> Maybe (Html msg) -> Html msg
layout header main maybeFooter =
    let
        footer =
            case maybeFooter of
                Just content ->
                    [ content ]

                Nothing ->
                    []
    in
    layoutGrid
        [ alignMiddle
        , style "text-align" "center"
        , style "align-items" "center"
        , style "margin" "auto"
        ]
        [ layoutGridInner []
            [ layoutGridCell [] [ header ]
            , layoutGridCell [] [ main ]
            , layoutGridCell [] footer
            ]
        ]


styles : { onMobileOnly : List (Attribute msg), notOnMobile : List (Attribute msg) }
styles =
    { onMobileOnly =
        [ style "class" "mdc-layout-grid__cell--span-0-desktop mdc-layout-grid__cell--span-0-tablet" ]
    , notOnMobile =
        [ style "class" "mdc-layout-grid__cell--span-0-phone" ]
    }
