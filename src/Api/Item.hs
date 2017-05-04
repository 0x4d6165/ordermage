{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Api.Item where

import Control.Monad.IO.Class (liftIO)
import Data.Maybe (listToMaybe)
import Database.PostgreSQL.Simple (Connection)
import Models.Item
import Queries.Item
import Servant
import qualified Opaleye as O

type ItemApi =
  Get '[JSON] [ItemRead]                                      :<|>
  Capture "itemId" ItemId     :> Get '[JSON] (Maybe ItemRead) :<|>
  ReqBody '[JSON] ItemWrite   :> Post '[JSON] (Maybe ItemId)

itemServer :: Connection -> Server ItemApi
itemServer con =
  getItems con    :<|>
  getItemById con :<|>
  postItem con

getItems :: Connection -> Handler [ItemRead]
getItems con = liftIO $ O.runQuery con itemsQuery

getItemById :: Connection -> ItemId -> Handler (Maybe ItemRead)
getItemById con itemID = liftIO $ listToMaybe <$> O.runQuery con (itemByIdQuery itemID)

postItem :: Connection -> ItemWrite -> Handler (Maybe ItemId)
postItem con item = liftIO $ listToMaybe <$>
  O.runInsertManyReturning con itemTable [itemToPG item] _itemId
