module Data.Common exposing (..)

import Data.Event exposing (..)


type Msg
    = NoOp
    | ShowEditor
    | GetEvents
    | GotEvents EventsResult
    | EditJson String


type DashboardMode
    = Data
    | Editor


type alias Model =
    { error : String
    , events : Events
    , json : String
    , mode : DashboardMode
    }
