{-# LANGUAGE Arrows #-}

module Queries.Order where

import qualified Opaleye as O
import Opaleye ((.==))
import Control.Arrow (returnA)
import Models.Order

ordersQuery :: O.Query OrderColRead
ordersQuery = O.queryTable orderTable

orderByIdQuery :: OrderId -> O.Query OrderColRead
orderByIdQuery orderID = proc () -> do
  orders <- ordersQuery -< ()
  O.restrict -< _orderId orders .== O.pgUUID (fromOrderId orderID)
  returnA -< orders
