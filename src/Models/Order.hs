{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Models.Order where

import Data.Aeson
import Data.UUID
import GHC.Generics
import Data.Time.Clock
import Models.User
import Models.Item

-- * order info
newtype OrderId = OrderId UUID
  deriving (Eq, Show, Generic)

toOrderId :: UUID -> OrderId
toOrderId = OrderId

data Order
  = Order {
    orderId    :: OrderId,
    orderItems :: [ItemId],
    orderUser  :: UserId,
    orderDate  :: UTCTime
  }
  deriving (Eq, Show, Generic)

instance ToJSON Order where
  toJSON Order{..} = object [
    "orderId"    .= show orderId,
    "orderItems" .= show orderItems,
    "orderUser"  .= show orderUser,
    "orderDate"  .= show orderDate ]

instance FromJSON OrderId where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return $ toOrderId uuid

instance FromJSON Order
