module FormBuilder.Photo.Attributes exposing (PhotoAttributes, defaultAttributes, selection)

{-| Attributes of the photo selector.

# Type
@docs PhotoAttributes

# Attributes
@docs defaultAttributes
@docs selection
-}

import FormBuilder.FieldBuilder.Attributes as Attributes exposing (FieldAttributes)
import FormBuilder.FieldBuilder.Events as Events


type alias PhotosAlbums =
    List ( String, List String )


{-| Attributes of the photo field. Expand FormBuilder.
-}
type alias PhotoAttributes msg =
    { photosAlbums : Maybe PhotosAlbums
    , selectedPhotoId : Maybe String
    , onPhotoClick : Maybe (Events.Event msg)
    }


{-| Default Attributes of the photo field.
-}
defaultAttributes : FieldAttributes (PhotoAttributes msg) msg
defaultAttributes =
    { common = Attributes.commonAttributes
    , photosAlbums = Nothing
    , selectedPhotoId = Nothing
    , onPhotoClick = Nothing
    }


{-| Set the different parameters for the photos selection.
- photos is list of labelled lists (List (String, List String)) of URLs.
- selectedPhotoId is a Maybe String, containing the selected photo if any.
- onPhotoClick represent the message to send when a photo is clicked.
- fieldAttributes are the attributes of the field.
-}
selection :
    Maybe PhotosAlbums
    -> Maybe String
    -> (String -> msg)
    -> FieldAttributes (PhotoAttributes msg) msg
    -> FieldAttributes (PhotoAttributes msg) msg
selection photos selectedPhotoId onPhotoClick fieldAttributes =
    { fieldAttributes
        | photosAlbums = photos
        , selectedPhotoId = selectedPhotoId
        , onPhotoClick = Just onPhotoClick
    }
