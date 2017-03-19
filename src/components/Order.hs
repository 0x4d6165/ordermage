{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Order where

import Control.Monad.Trans.Except
import Data.Aeson
import Data.UUID
import GHC.Generics
import Servant
import Utils
import Data.Time.Clock
import System.IO.Unsafe (unsafePerformIO)

type OrderApi =
  "order" :> Get '[JSON] [Order] :<|>
  "order" :> Capture "orderId" Integer :> Get '[JSON] Order

orderServer :: Server OrderApi
orderServer =
  getOrders :<|>
  getOrderById

getOrders :: Handler [Order]
getOrders = return [exampleOrder]

getOrderById :: Integer -> Handler Order
getOrderById = \ case
  0 -> return exampleOrder
  _ -> throwE err404

exampleOrder :: Order
exampleOrder = Order (genV5UUID "ordermage-example-orders") [] (genV5UUID "ordermange-user-example") (unsafePerformIO getCurrentTime)

-- * order info
type Items = [UUID]
type OrderUserID = UUID

data Order
  = Order {
    orderId :: UUID,
    orderItems :: Items,
    orderUser :: OrderUserID,
    orderDate :: UTCTime
  }
  deriving (Eq, Show, Generic)

instance ToJSON Order where
  toJSON (Order orderId orderItems orderUser orderDate) =
    object ["orderId" .= show orderId, "orderItems" .= show orderItems, "orderUser" .= show orderUser, "orderDate" .= show orderDate]

instance FromJSON UUID where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return uuid

instance FromJSON Order
