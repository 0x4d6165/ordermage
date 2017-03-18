{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Item where

import Control.Monad.Trans.Except
import Data.Aeson
import Data.UUID
import GHC.Generics
import Servant
import Utils

type ItemApi =
  "item" :> Get '[JSON] [Item] :<|>
  "item" :> Capture "itemId" Integer :> Get '[JSON] Item

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
exampleItem = Item (genV5UUID "ordermage-example-items") "example item"

-- * item info

data Item
  = Item {
    itemId :: UUID,
    itemText :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON Item where
  toJSON (Item itemId itemText) =
      object ["itemId" .= show itemId, "itemText" .= itemText]

instance FromJSON UUID where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return uuid

instance FromJSON Item
