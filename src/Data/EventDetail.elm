module Data.EventDetail exposing (EventDetail, decoder, default)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (..)


type alias EventDetail =
    { id : Maybe String
    , imageLocation : Maybe String
    , accountId : Maybe Int
    }


{-| Defaults to Nothing.
-}
default : EventDetail
default =
    EventDetail Nothing Nothing Nothing


decoder : Decoder EventDetail
decoder =
    D.succeed EventDetail
        |> optional "id" (D.nullable D.string) Nothing
        |> optional "imageLocation" (D.nullable D.string) Nothing
        |> optional "accountId" (D.nullable D.int) Nothing
