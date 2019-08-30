module View.Dashboard exposing (view)

import Data.Common exposing (..)
import Data.Event exposing (..)
import Data.EventDetail exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


view : Model -> Html Msg
view model =
    div [ class "container w-full mx-auto pt-20" ]
        [ div [ class "w-full px-4 md:px-0 md:mt-8 mb-16 text-gray-800 leading-normal" ]
            [ div
                [ class "flex flex-wrap" ]
                [ alerts model
                , model.events
                    |> Data.Event.getCompanyId
                    |> companyData
                    |> metric companyIcon
                , model.events
                    |> List.length
                    |> countData
                    |> metric countIcon
                , model.events
                    |> Data.Event.runsheetsLength
                    |> runsheetsData
                    |> metric runsheetsIcon
                , model.events
                    |> Data.Event.errorsLength
                    |> errorsData
                    |> metric errorsIcon
                , board model
                ]
            ]
        ]


board : Model -> Html Msg
board m =
    div [ class "w-full p-3" ]
        [ div
            [ class "bg-gray-900 border border-gray-800 rounded shadow" ]
            [ div
                [ class "w-full container mx-auto flex flex-wrap border-b border-gray-800 p-3" ]
                [ div [ class "w-1/2" ] [ boardTitle ]
                , div [ class "w-1/2" ] [ boardTabs m ]
                ]
            , div [ class "p-5" ] [ dataViewer m, jsonInput m ]
            ]
        ]


boardTabs : Model -> Html Msg
boardTabs model =
    div
        [ class "float-right" ]
        [ ul [ class "flex" ]
            [ li [ class "-mb-px mr-1" ]
                [ dataTab model
                ]
            , li
                [ class "mr-1" ]
                [ editorTab model ]
            ]
        ]


tabCss : Bool -> String
tabCss b =
    if b then
        activeTabCss
    else
        inactiveTabCss


activeTabCss : String
activeTabCss =
    "inline-block border border-blue-500 rounded  py-1 px-3 bg-blue-500 text-white"


inactiveTabCss : String
inactiveTabCss =
    "inline-block border rounded border-gray-800 hover:border-gray-600 text-blue-500 hover:bg-gray-800 py-1 px-3"


dataTab : Model -> Html Msg
dataTab m =
    let
        css =
            tabCss (m.mode == Data)
    in
    a [ class css, href "#", onClick GetEvents ] [ text "Data" ]


editorTab : Model -> Html Msg
editorTab m =
    let
        css =
            tabCss (m.mode == Editor)
    in
    a [ class css, href "#", onClick ShowEditor ] [ text "JSON" ]


boardTitle : Html Msg
boardTitle =
    h5 [ class "font-bold uppercase text-gray-600" ]
        [ text "Data" ]


alerts : Model -> Html Msg
alerts m =
    if String.isEmpty m.error then
        text ""
    else
        div [ class "flex w-full justify-center" ] [ alertError m ]


alertError : Model -> Html Msg
alertError m =
    div
        [ class "w-full md:w-1/2 xl:w-1/3 bg-red-300 border-t border-b border-red-500 text-teal-900 px-4 py-3 shadow-md"
        ]
        [ div
            [ class "flex" ]
            [ div [ class "px-2" ] [ i [ class "fa fa-exclamation-triangle" ] [] ]
            , div [] [ p [ class "font-bold" ] [ text m.error ] ]
            ]
        ]


metric : Html Msg -> Html Msg -> Html Msg
metric icon data =
    div
        [ class "w-full md:w-1/2 xl:w-1/4 p-3" ]
        [ div
            [ class "bg-gray-900 border border-gray-800 rounded shadow p-2" ]
            [ div [ class "flex flex-row items-center" ] [ icon, data ] ]
        ]


companyIcon : Html Msg
companyIcon =
    div [ class "flex-shrink pr-4" ]
        [ div [ class "rounded p-3 bg-green-600" ]
            [ i [ class "fa fa-building fa-2x fa-fw fa-inverse" ] [] ]
        ]


countIcon : Html Msg
countIcon =
    div [ class "flex-shrink pr-4" ]
        [ div [ class "rounded p-3 bg-pink-600" ]
            [ i [ class "fa fa-list-ol fa-2x fa-fw fa-inverse" ] [] ]
        ]


runsheetsIcon : Html Msg
runsheetsIcon =
    div [ class "flex-shrink pr-4" ]
        [ div [ class "rounded p-3 bg-yellow-600" ]
            [ i [ class "fa fa-file-text fa-2x fa-fw fa-inverse" ] [] ]
        ]


errorsIcon : Html Msg
errorsIcon =
    div [ class "flex-shrink pr-4" ]
        [ div [ class "rounded p-3 bg-red-600" ]
            [ i [ class "fa fa-exclamation fa-2x fa-fw fa-inverse" ] [] ]
        ]


companyData : Maybe Int -> Html Msg
companyData maybeId =
    div [ class "flex-1 text-right md:text-center" ]
        [ h5 [ class "font-bold uppercase text-gray-400" ] [ text "Company" ]
        , h3 [ class "font-bold text-3xl text-gray-600" ]
            [ case maybeId of
                Nothing ->
                    text ""

                Just id ->
                    String.fromInt id |> text
            ]
        ]


countData : Int -> Html Msg
countData count =
    div [ class "flex-1 text-right md:text-center" ]
        [ h5 [ class "font-bold uppercase text-gray-400" ] [ text "Count" ]
        , h3 [ class "font-bold text-3xl text-gray-600" ] [ text (String.fromInt count) ]
        ]


runsheetsData : Int -> Html Msg
runsheetsData count =
    div [ class "flex-1 text-right md:text-center" ]
        [ h5 [ class "font-bold uppercase text-gray-400" ] [ text "Runsheets" ]
        , h3 [ class "font-bold text-3xl text-gray-600" ] [ text (String.fromInt count) ]
        ]


errorsData : Int -> Html Msg
errorsData count =
    div [ class "flex-1 text-right md:text-center" ]
        [ h5 [ class "font-bold uppercase text-gray-400" ] [ text "Errors" ]
        , h3 [ class "font-bold text-3xl text-gray-600" ] [ text (String.fromInt count) ]
        ]


jsonInput : Model -> Html Msg
jsonInput m =
    if m.mode == Editor then
        jsonEditor m
    else
        text ""


jsonEditor : Model -> Html Msg
jsonEditor m =
    textarea
        [ onInput EditJson, class "bg-gray-800 text-yellow-600 p-3 w-full h-56" ]
        [ text m.json ]


dataViewer : Model -> Html Msg
dataViewer m =
    if m.mode == Data then
        div [] [ dataTable m ]
    else
        text ""


dataTable : Model -> Html Msg
dataTable m =
    let
        events =
            case m.events |> List.tail of
                Just xs ->
                    xs

                Nothing ->
                    []
    in
    table [ class "w-full p-5 text-gray-700" ]
        [ thead []
            [ tr []
                [ th [ class "text-left text-gray-600" ] [ text "Event" ]
                , th [ class "text-left text-gray-600" ] [ text "Tags" ]
                ]
            ]
        , events |> List.map dataRow |> tbody []
        ]


dataRow : Event -> Html Msg
dataRow event =
    tr [ class "border-b border-gray-700" ]
        [ td [] [ dataEvent event ]
        , event.tags |> List.map tag |> td []
        ]


tag : String -> Html Msg
tag label =
    span [ class "inline-block bg-gray-300 rounded-full px-1 py text-sm font-semibold text-gray-700 mr-1" ]
        [ text label ]


dataEvent : Event -> Html Msg
dataEvent e =
    div []
        [ span [ class "text-gray-500" ] [ text e.message ]
        , details e.details
        ]


details : Maybe EventDetail -> Html msg
details maybeDetail =
    case maybeDetail of
        Nothing ->
            text ""

        Just detail ->
            ul []
                [ li [] [ detailId detail.id ]
                , li [] [ detailAccountId detail.accountId ]
                , li [] [ detailImageLocation detail.imageLocation ]
                ]


detailId : Maybe String -> Html msg
detailId id =
    case id of
        Nothing ->
            text ""

        Just x ->
            div [] [ "Id: " ++ x |> text ]


detailAccountId : Maybe Int -> Html msg
detailAccountId id =
    case id of
        Nothing ->
            text ""

        Just x ->
            div [] [ "Account Id: " ++ String.fromInt x |> text ]


detailImageLocation : Maybe String -> Html msg
detailImageLocation img =
    case img of
        Nothing ->
            text ""

        Just x ->
            div [] [ "Img: " ++ x |> text ]
