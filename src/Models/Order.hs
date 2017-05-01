{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE RecordWildCards       #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module Models.Order where

import Control.Monad (mzero)
import Data.Aeson
import Data.ByteString (ByteString)
import Data.Time.Clock (UTCTime)
import Data.Profunctor.Product.TH (makeAdaptorAndInstance)
import Data.Text (pack, Text)
import Data.UUID
import GHC.Generics
import Models.Item
import Web.HttpApiData (FromHttpApiData, parseUrlPiece, parseHeader)
import qualified Opaleye as O
{-import Models.User-}

-- * order info
newtype OrderId = OrderId UUID
  deriving (Eq, Show, Generic)

toOrderId :: UUID -> OrderId
toOrderId = OrderId

fromOrderId :: OrderId -> UUID
fromOrderId (OrderId x) = x

fromTextOrderId :: Text -> Maybe OrderId
fromTextOrderId x = case fromText x of
                      Nothing   -> Nothing
                      Just uuid -> Just $ toOrderId uuid

fromASCIIBytesOrderId :: ByteString -> Maybe OrderId
fromASCIIBytesOrderId x = case fromASCIIBytes x of
                           Nothing   -> Nothing
                           Just uuid -> Just $ toOrderId uuid

data Order' id items {-user-} date
  = Order {
    _orderId    :: id,
    _orderItems :: items,
    {-_orderUser  :: user,-}
    _orderDate  :: date
  }
  deriving (Eq, Show, Generic)

type OrderRead     = Order' OrderId [ItemId] UTCTime
type OrderWrite    = Order' (Maybe OrderId) [ItemId] (Maybe UTCTime)
type OrderColRead  = Order' (O.Column O.PGUuid)
                            (O.Column (O.PGArray O.PGUuid))
                            (O.Column O.PGTimestamptz)

type OrderColWrite = Order' (Maybe (O.Column O.PGUuid))
                            (O.Column (O.PGArray O.PGUuid))
                            (Maybe (O.Column O.PGTimestamptz))

instance ToJSON OrderRead where
  toJSON Order{..} = object [
    "orderId"    .= show _orderId,
    "orderItems" .= _orderItems,
    {-"orderUser"  .= show _orderUser,-}
    "orderDate"  .= show _orderDate ]

instance ToJSON OrderId where
  toJSON = String . pack . show . fromOrderId

instance FromJSON OrderId where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return $ toOrderId uuid

instance FromJSON OrderWrite where
  parseJSON (Object o) = Order <$>
                              o .:? "_orderId"    <*>
                              o .:  "_orderItems" <*>
                              o .:? "_orderDate"
  parseJSON _ = mzero

$(makeAdaptorAndInstance "pOrder" ''Order')

orderTable :: O.Table OrderColWrite OrderColRead
orderTable = O.Table "orders" (pOrder Order { _orderId     = O.optional "id"
                                            , _orderItems  = O.required "items"
                                             {-, _orderUser = O.required "orderUser"-}
                                            , _orderDate   = O.optional "orderdate"
                                            })

orderToPG :: OrderWrite -> OrderColWrite
orderToPG = pOrder Order { _orderId    = const Nothing
                         , _orderItems = O.pgArray pgItemId
                         , _orderDate  = const Nothing
                         }

instance O.QueryRunnerColumnDefault O.PGUuid OrderId where
  queryRunnerColumnDefault =
    O.queryRunnerColumn id OrderId O.queryRunnerColumnDefault

instance FromHttpApiData OrderId where
  parseUrlPiece = maybe (Left "invalid UUID") Right . fromTextOrderId
  parseHeader   = maybe (Left "invalid UUID") Right . fromASCIIBytesOrderId
