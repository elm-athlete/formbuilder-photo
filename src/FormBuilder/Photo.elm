module FormBuilder.Photo exposing (default)

{-| Create a photo selector field in FormBuilder.

@docs default
-}

import Html exposing (Html)
import Html.Attributes
import Html.Events
import FormBuilder.FieldBuilder.Attributes as Attributes exposing (FieldAttributes, AttributesModifier)
import FormBuilder.FieldBuilder as FieldBuilder exposing (FieldView)
import FormBuilder.Photo.Attributes exposing (..)
import Maybe exposing (andThen, withDefault)


{-| Generates a default photo selector field.
-}
default : List (AttributesModifier (PhotoAttributes msg) msg) -> Html msg
default =
    FieldBuilder.object defaultAttributes (Just input)


selectableImage : String -> (String -> msg) -> String -> Html msg
selectableImage selectedSource event source =
    let
        selected =
            source == selectedSource
    in
        Html.div
            [ Html.Attributes.style
                [ ( "opacity"
                  , if selected then
                        "1"
                    else
                        "0.5"
                  )
                , ( "display", "inline-block" )
                ]
            , Html.Events.onClick (event source)
            ]
            [ Html.img
                [ Html.Attributes.style [ ( "cursor", "pointer" ) ]
                , Html.Attributes.width 200
                , Html.Attributes.src source
                ]
                []
            ]


photosAlbumsView :
    (String -> msg)
    -> Maybe String
    -> ( String, List String )
    -> Html msg
photosAlbumsView event selectedPhotoId (( name, photos ) as photosAlbum) =
    if List.isEmpty photos then
        Html.text ""
    else
        Html.div []
            [ Html.div []
                [ Html.text name ]
            , Html.div
                [ Html.Attributes.style
                    [ ( "overflow-x", "auto" )
                    , ( "white-space", "nowrap" )
                    ]
                ]
                (photos
                    |> List.map (\photo -> selectableImage (selectedPhotoId |> withDefault photo) event photo)
                    |> List.reverse
                )
            ]


photoEvent : FieldView (PhotoAttributes msg) msg
photoEvent { photosAlbums, selectedPhotoId, onPhotoClick } =
    case onPhotoClick of
        Just event ->
            Html.div
                []
                [ if photosAlbums == Nothing then
                    Html.text ""
                  else
                    Html.div
                        []
                        (photosAlbums
                            |> withDefault []
                            |> List.map (photosAlbumsView event selectedPhotoId)
                        )
                ]

        Nothing ->
            Html.text ""


input : FieldView (PhotoAttributes msg) msg
input attributes =
    Html.div
        []
        [ photoEvent attributes
        , FieldBuilder.defaultHidden
            [ Attributes.objectName <| Maybe.withDefault "" <| attributes.common.objectName
            , Attributes.fieldName <| Maybe.withDefault "" <| attributes.common.fieldName
            , Attributes.value <| Maybe.withDefault "" <| attributes.common.value
            ]
        ]
