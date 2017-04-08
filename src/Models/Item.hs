{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Models.Item where

import Data.Aeson
import Data.Text
import Data.Time.Clock
import Data.UUID
import GHC.Generics

newtype ItemId = ItemId UUID
  deriving (Show, Eq, Generic)

toItemId :: UUID -> ItemId
toItemId = ItemId

data Item
  = Item {
    itemId          :: ItemId,
    itemText        :: Text,
    numTimesOrdered :: Integer,
    mostRecentOrder :: UTCTime
  }
  deriving (Eq, Show, Generic)

instance ToJSON Item where
  toJSON Item{..} = object [
    "itemId"          .= show itemId,
    "itemText"        .= itemText,
    "numTimesOrdered" .= numTimesOrdered,
    "mostRecentOrder" .= show numTimesOrdered ]

instance FromJSON ItemId where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return $ toItemId uuid

instance FromJSON Item
