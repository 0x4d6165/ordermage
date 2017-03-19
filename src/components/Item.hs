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
import Data.Time.Clock
import System.IO.Unsafe (unsafePerformIO)

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
exampleItem = Item (genV5UUID "ordermage-example-items") "example item" 1 (unsafePerformIO getCurrentTime)

-- * item info

data Item
  = Item {
    itemId :: UUID,
    itemText :: String,
    numTimesOrdered :: Integer,
    mostRecentOrder :: UTCTime
  }
  deriving (Eq, Show, Generic)

instance ToJSON Item where
  toJSON (Item itemId itemText numTimesOrdered mostRecentOrder) =
    object ["itemId" .= show itemId, "itemText" .= itemText, "numTimesOrdered" .= numTimesOrdered, "mostRecentOrder" .= show numTimesOrdered]

instance FromJSON UUID where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return uuid

instance FromJSON Item
