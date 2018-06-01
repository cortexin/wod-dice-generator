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


historyRoll : Int -> Int -> Html Msg
historyRoll thresh i =
    span
        [ class
            (if i >= thresh then
                "teal-text"
             else
                "red-text"
            )
        ]
        [ text ((toString i) ++ " ") ]


checkRoll : Int -> Int -> Int -> Int
checkRoll threshold roll aggregate =
    case roll >= threshold of
        True ->
            aggregate + 1

        False ->
            if roll == 1 then
                aggregate - 1
            else
                aggregate


entryResult : Model -> HistoryEntry -> Html Msg
entryResult model entry =
    let
        x =
            List.foldr (checkRoll model.successThreshold) 0 entry
    in
        if x <= 0 then
            span [ class "right red-text" ] [ text "FAIL" ]
        else
            span [ class "right teal-text" ] [ text (String.repeat x "★") ]


historyEntry : Model -> HistoryEntry -> Html Msg
historyEntry model entry =
    li [ class "collection-item " ]
        (List.concat
            [ List.map (historyRoll model.successThreshold) entry
            , [ entryResult model entry ]
            ]
        )


successThresholdInput : Model -> Html Msg
successThresholdInput model =
    div [ class "col s3" ]
        [ label [] [ text "Success Threshold" ]
        , input
            [ type_ "number"
            , onInput ChangeThreshold
            , value (toString model.successThreshold)
            ]
            []
        ]


numThrowsInput : Model -> Html Msg
numThrowsInput model =
    div [ class "col s3" ]
        [ label [] [ text "№ of dies" ]
        , input
            [ type_ "number"
            , onInput ChangeThrows
            , value (toString model.dieThrows)
            ]
            []
        ]


numSidesInput : Model -> Html Msg
numSidesInput model =
    div [ class "col s3" ]
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
        , numThrowsInput model
        , div [ class "col s3" ] [ button [ class "btn", onClick Roll ] [ text "Roll" ] ]
        ]


type alias Model =
    { dieSides : Int
    , successThreshold : Int
    , dieThrows : Int
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
    | NewRolls HistoryEntry
    | ChangeSides String
    | ChangeThreshold String
    | ChangeThrows String


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

        Result.Err _ ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewRolls (rollGenerator model.dieThrows model.dieSides) )

        NewRolls rolls ->
            ( { model | history = rolls :: model.history }, Cmd.none )

        ChangeSides newSides ->
            case toInt newSides of
                Result.Ok x ->
                    ( { model | dieSides = x }, Cmd.none )

                Result.Err _ ->
                    ( model, Cmd.none )

        ChangeThreshold newThreshold ->
            parseThreshold newThreshold model

        ChangeThrows newThrows ->
            case toInt newThrows of
                Result.Ok x ->
                    ( { model | dieThrows = x }, Cmd.none )

                Result.Err _ ->
                    ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( Model 6 4 4 [], Cmd.none )
