{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Api.Order where

import Control.Monad.IO.Class (liftIO)
import Data.Maybe (listToMaybe)
import Database.PostgreSQL.Simple (Connection)
import Models.Order
import Queries.Order
import Servant
import qualified Opaleye as O

type OrderApi =
   Get '[JSON] [OrderRead]                                        :<|>
   Capture "orderId" OrderId     :> Get '[JSON] (Maybe OrderRead) :<|>
   ReqBody '[JSON] OrderWrite   :> Post '[JSON] (Maybe OrderId)

orderServer :: Connection -> Server OrderApi
orderServer con =
  getOrders con    :<|>
  getOrderById con :<|>
  postOrder con

getOrders :: Connection -> Handler [OrderRead]
getOrders con = liftIO $ O.runQuery con ordersQuery

getOrderById :: Connection -> OrderId -> Handler (Maybe OrderRead)
getOrderById con orderID = liftIO $ listToMaybe <$> O.runQuery con (orderByIdQuery orderID)

postOrder :: Connection -> OrderWrite -> Handler (Maybe OrderId)
postOrder con order = liftIO $ listToMaybe <$>
  O.runInsertManyReturning con orderTable [orderToPG order] _orderId
