module Error exposing (buildErrorMessage, viewMaybeError, viewError)

import Html exposing (Html, div, h3, text)
import Http

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


viewMaybeError: String -> Maybe String -> Html msg
viewMaybeError action maybeError =
    case maybeError of
        Just error ->
            viewError action error
        Nothing ->
            text ""


viewError : String -> String -> Html msg
viewError action error =
    let
        errorHeading =
            "Couldn't " ++ action ++ " at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ error)
        ]
