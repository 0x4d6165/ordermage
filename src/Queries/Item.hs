{-# LANGUAGE Arrows #-}

module Queries.Item where

import qualified Opaleye as O
import Opaleye ((.==))
import Control.Arrow (returnA)
import Models.Item

itemsQuery :: O.Query ItemColRead
itemsQuery = O.queryTable itemTable

itemByIdQuery :: ItemId -> O.Query ItemColRead
itemByIdQuery itemID = proc () -> do
  items <- itemsQuery -< ()
  O.restrict -< _itemId items .== O.pgUUID (fromItemId itemID)
  returnA -< items
