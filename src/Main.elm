module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Random


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias History =
    List Int


historyEntry : Int -> Html Msg
historyEntry i =
    li [] [ span [] [ text (toString i) ] ]


type alias Model =
    { dieFace : Int
    , dieSides : Int
    , history : History
    }


view : Model -> Html Msg
view model =
    div [ class "clearfix mxn2" ]
        [ div [ class "col-3 mx-auto" ]
            [ h1 [] [ text (toString model.dieFace) ]
            , button [ onClick Roll ] [ text "Roll" ]
            ]
        , div [ class "col-3 mx-auto" ]
            [ ul [] (List.map historyEntry model.history) ]
        ]


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 model.dieSides) )

        NewFace newFace ->
            ( { model | dieFace = newFace, history = newFace :: model.history }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( Model 1 6 [], Cmd.none )
