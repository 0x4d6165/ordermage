{-# LANGUAGE DataKinds #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Api.Item where

import Control.Monad.Trans.Except
import Data.Time.Clock
import Servant
import System.IO.Unsafe (unsafePerformIO)
import Utils
import Models.Item

type ItemApi =
   Get '[JSON] [Item] :<|>
   Capture "itemId" Integer :> Get '[JSON] Item

itemServer :: Server ItemApi
itemServer =
  getItems :<|>
  getItemById

getItems :: Handler [Item]
getItems = return [exampleItem]

getItemById :: Integer -> Handler Item
getItemById = \ case
  0 -> return exampleItem
  _ -> throwE err404

exampleItem :: Item
exampleItem = Item (toItemId $ genV5UUID "ordermage-example-items") "example item" 1 (unsafePerformIO getCurrentTime)
