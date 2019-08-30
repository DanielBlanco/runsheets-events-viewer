module View.Footer exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


view : Html msg
view =
    footer
        [ class "bg-gray-900 border-t border-gray-400 shadow" ]
        [ div
            [ class "container max-w-md mx-auto flex py-8" ]
            [ div
                [ class "w-full mx-auto flex flex-wrap" ]
                [ footerCol about
                , footerCol social
                ]
            ]
        ]


footerCol : Html msg -> Html msg
footerCol a =
    div [ class "flex w-full md:w-1/2" ] [ a ]


about : Html msg
about =
    div [ class "px-8" ]
        [ title "About"
        , p [ class "py-4 text-gray-600 text-sm" ]
            [ text "Custom app that reads and visualizes JSON data."
            ]
        ]


social : Html msg
social =
    div
        [ class "px-8" ]
        [ title "Social"
        , ul
            [ class "list-reset items-center text-sm pt-3" ]
            [ socialLink "https://github.com/DanielBlanco" "Github"
            , socialLink "https://twitter.com/dblancorojas" "Twitter"
            , socialLink "https://elm-lang.org/" "About ELM"
            ]
        ]


socialLink : String -> String -> Html msg
socialLink url t =
    li
        []
        [ a
            [ class "inline-block text-gray-600 no-underline hover:text-gray-100 hover:text-underline py-1"
            , href url
            ]
            [ text t ]
        ]


title : String -> Html msg
title a =
    h3 [ class "font-bold font-bold text-gray-100" ] [ text a ]
