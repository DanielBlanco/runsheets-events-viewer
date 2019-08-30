module Data.Event
    exposing
        ( Event
        , Events
        , EventsResult
        , decodeJson
        , errorsLength
        , getCompanyId
        , runsheetsLength
        )

import Data.EventDetail exposing (..)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (..)


type alias Events =
    List Event


type alias Event =
    { message : String
    , tags : List String
    , details : Maybe EventDetail
    }


type alias EventsResult =
    Result D.Error Events



---- STATS ----


boolToInt : Bool -> Int
boolToInt b =
    if b then
        1
    else
        0


runsheetsLength : Events -> Int
runsheetsLength events =
    let
        error e =
            e |> hasRunsheetsTag |> boolToInt |> (+)
    in
    List.foldl error 0 events


errorsLength : Events -> Int
errorsLength events =
    let
        error e =
            e |> hasErrorTag |> boolToInt |> (+)
    in
    List.foldl error 0 events


hasRunsheetsTag : Event -> Bool
hasRunsheetsTag e =
    let
        tags =
            String.join " " e.tags
    in
    String.contains "info" tags && String.contains "runsheet" tags


hasErrorTag : Event -> Bool
hasErrorTag e =
    e.tags
        |> String.join " "
        |> String.contains "error"


getCompanyId : Events -> Maybe Int
getCompanyId events =
    case events of
        [] ->
            Nothing

        x :: _ ->
            let
                detail =
                    x.details |> Maybe.withDefault Data.EventDetail.default
            in
            detail.accountId



---- DECODERS ----


decodeJson : String -> Result D.Error Events
decodeJson json =
    D.decodeString listDecoder json


{-| Decodes a list of Events.
-}
listDecoder : Decoder Events
listDecoder =
    D.list decoder


decoder : Decoder Event
decoder =
    D.succeed Event
        |> required "message" D.string
        |> required "tags" (D.list D.string)
        |> required "details" (D.nullable Data.EventDetail.decoder)
