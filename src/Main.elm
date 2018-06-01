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


type alias History =
    List Int


historyEntry : Int -> Html Msg
historyEntry i =
    li [] [ span [] [ text (toString i) ] ]


dieInput : Model -> Html Msg
dieInput model =
    div [ class "clearfix" ]
        [ div [ class "col col-6" ] [ input [ placeholder "№ of sides", type_ "number", onInput ChangeSides ] [ text (toString model.dieSides) ] ]
        , div [ class "col col-6" ] [ button [ onClick Roll ] [ text "Roll" ] ]
        ]


type alias Model =
    { dieFace : Int
    , dieSides : Int
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
    | NewFace Int
    | ChangeSides String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 model.dieSides) )

        NewFace newFace ->
            ( { model | dieFace = newFace, history = newFace :: model.history }, Cmd.none )

        ChangeSides newSides ->
            case toInt newSides of
                Result.Ok x ->
                    ( { model | dieSides = x }, Cmd.none )

                Result.Err _ ->
                    ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( Model 1 6 [], Cmd.none )
