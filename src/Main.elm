module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, value, style)
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


historyThrow : Int -> Int -> Html Msg
historyThrow thresh i =
    span
        [ class
            (if i >= thresh then
                "teal-text"
             else
                "red-text"
            )
        ]
        [ text ((toString i) ++ " ") ]


historyEntry : Model -> HistoryEntry -> Html Msg
historyEntry model entry =
    li [ class "collection-item" ]
        (List.map
            (historyThrow model.successThreshold)
            entry
        )


successThresholdInput : Model -> Html Msg
successThresholdInput model =
    div [ class "col s4" ]
        [ label [] [ text "Success Threshold" ]
        , input
            [ type_ "number"
            , onInput ChangeThreshold
            , value (toString model.successThreshold)
            ]
            []
        ]


numSidesInput : Model -> Html Msg
numSidesInput model =
    div [ class "col s4" ]
        [ label [] [ text "№ of sides" ]
        , input
            [ type_ "number"
            , onInput ChangeSides
            , value (toString model.dieSides)
            ]
            []
        ]


dieInput : Model -> Html Msg
dieInput model =
    div [ class "row" ]
        [ numSidesInput model
        , successThresholdInput model
        , div [ class "col s4" ] [ button [ class "btn", onClick Roll ] [ text "Roll" ] ]
        ]


type alias Model =
    { dieSides : Int
    , successThreshold : Int
    , numDice : Int
    , history : History
    }


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ dieInput model
        , ul [ class "collection" ] (List.map (historyEntry model) model.history)
        ]


type Msg
    = Roll
    | NewFace HistoryEntry
    | ChangeSides String
    | ChangeThreshold String


rollGenerator : Int -> Int -> Random.Generator (List Int)
rollGenerator len sides =
    Random.list len (Random.int 1 sides)


parseThreshold : String -> Model -> ( Model, Cmd Msg )
parseThreshold newThreshold model =
    case toInt newThreshold of
        Result.Ok x ->
            case x <= model.dieSides of
                True ->
                    ( { model | successThreshold = x }, Cmd.none )

                False ->
                    ( model, Cmd.none )

        Result.Err msg ->
            ( model, Cmd.none )


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

        ChangeThreshold newThreshold ->
            parseThreshold newThreshold model


init : ( Model, Cmd Msg )
init =
    ( Model 6 4 4 [], Cmd.none )
