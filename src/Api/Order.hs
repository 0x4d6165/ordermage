{-# LANGUAGE DataKinds #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Api.Order where

import Control.Monad.Trans.Except
import Data.Time.Clock
import Models.Order
import Models.User
import Servant
import System.IO.Unsafe (unsafePerformIO)
import Utils

type OrderApi =
  Get '[JSON] [Order] :<|>
  Capture "orderId" Integer :> Get '[JSON] Order

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
exampleOrder = Order (toOrderId $ genV5UUID "ordermage-example-orders") [] (toUserId $ genV5UUID "ordermange-user-example") (unsafePerformIO getCurrentTime)
