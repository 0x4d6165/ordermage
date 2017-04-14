{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Models.Order where

import Data.Aeson
import Data.UUID
import GHC.Generics
import Data.DateTime (DateTime)
import Models.User
import Models.Item

-- * order info
newtype OrderId = OrderId UUID
  deriving (Eq, Show, Generic)

toOrderId :: UUID -> OrderId
toOrderId = OrderId

data Order
  = Order {
    _orderId    :: OrderId,
    _orderItems :: [ItemId],
    _orderUser  :: UserId,
    _orderDate  :: DateTime
  }
  deriving (Eq, Show, Generic)

instance ToJSON Order where
  toJSON Order{..} = object [
    "orderId"    .= show _orderId,
    "orderItems" .= _orderItems,
    "orderUser"  .= show _orderUser,
    "orderDate"  .= show _orderDate ]

instance FromJSON OrderId where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return $ toOrderId uuid

instance FromJSON Order
