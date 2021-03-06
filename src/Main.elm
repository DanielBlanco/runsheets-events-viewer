module Main exposing (..)

import Browser
import Data.Common exposing (..)
import Data.Event exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Json.Decode as D exposing (Decoder)
import Regex
import View.Dashboard exposing (view)
import View.Footer exposing (view)
import View.Header exposing (view)


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { error = ""
    , events = []
    , json = "[]"
    , mode = Editor
    }



---- UPDATE ----
--- If want to debug Debug.log ("Oops! " ++ model.error ++ D.errorToString err)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetEvents ->
            update (model.json |> decodeJson |> GotEvents) model

        GotEvents (Ok events) ->
            ( { model | mode = Data, events = events }, Cmd.none )

        GotEvents (Err err) ->
            let
                newModel =
                    { model | error = "Cannot get events from your JSON!" }
            in
            ( newModel, Cmd.none )

        ShowEditor ->
            ( { model | events = [], error = "", mode = Editor }, Cmd.none )

        EditJson json ->
            ( { model | json = json |> removeNumberLong, error = "" }, Cmd.none )


removeNumberLong : String -> String
removeNumberLong json =
    let
        regex =
            Regex.fromString "NumberLong(\\([0-9]+\\))"
                |> Maybe.withDefault Regex.never
    in
    Regex.replace regex (\_ -> "0") json



---- VIEW ----


view : Model -> Html Msg
view m =
    div [ class "font-sans leading-normal tracking-normal" ]
        [ View.Header.view
        , View.Dashboard.view m
        , View.Footer.view
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
