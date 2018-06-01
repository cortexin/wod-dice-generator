module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    { dieFace : Int
    }


view : Model -> Html Msg
view model =
    div [ class "clearfix mxn2" ]
        [ div [ class "col-3 mx-auto" ]
            [ h1 [] [ text (toString model.dieFace) ]
            , button [ onClick Roll ] [ text "Roll" ]
            ]
        ]


type Msg
    = Roll


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( Model 1, Cmd.none )
