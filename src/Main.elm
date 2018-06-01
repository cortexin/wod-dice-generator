module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Random
import String exposing (toInt)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias HistoryEntry =
    List Int


type alias History =
    List HistoryEntry


historyEntry : HistoryEntry -> Html Msg
historyEntry i =
    li [] [ span [] [ text (toString i) ] ]


dieInput : Model -> Html Msg
dieInput model =
    div [ class "clearfix" ]
        [ div [ class "col col-6" ] [ input [ placeholder "№ of sides", type_ "number", onInput ChangeSides ] [ text (toString model.dieSides) ] ]
        , div [ class "col col-6" ] [ button [ onClick Roll ] [ text "Roll" ] ]
        ]


type alias Model =
    { dieSides : Int
    , numDice : Int
    , history : History
    }


view : Model -> Html Msg
view model =
    div [ class "clearfix mxn2" ]
        [ div [ class "col-3 mx-auto" ] [ dieInput model ]
        , div [ class "col-3 mx-auto" ]
            [ ul [] (List.map historyEntry model.history) ]
        ]


type Msg
    = Roll
    | NewFace HistoryEntry
    | ChangeSides String


rollGenerator : Int -> Int -> Random.Generator (List Int)
rollGenerator len sides =
    Random.list len (Random.int 1 sides)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (rollGenerator model.numDice model.dieSides) )

        NewFace newFace ->
            ( { model | history = newFace :: model.history }, Cmd.none )

        ChangeSides newSides ->
            case toInt newSides of
                Result.Ok x ->
                    ( { model | dieSides = x }, Cmd.none )

                Result.Err _ ->
                    ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( Model 6 4 [], Cmd.none )
