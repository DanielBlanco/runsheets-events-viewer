module View.Header exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


view : Html msg
view =
    nav [ class "bg-gray-900 fixed w-full z-10 top-0 shadow" ]
        [ div
            [ class "w-full container mx-auto flex flex-wrap items-center mt-0 pt-3 pb-3" ]
            [ title, other ]
        ]


title : Html msg
title =
    div [ class "w-1/2 pl-2 md:pl-0" ]
        [ a
            [ class "text-gray-100 text-base xl:text-xl no-underline hover:no-underline font-bold"
            , href "#"
            ]
            [ i [ class "fa fa-simplybuilt text-blue-400 pr-3" ] []
            , text "View JSON events"
            ]
        ]


other : Html msg
other =
    div [ class "w-1/2 pr-0" ] []
