{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE RecordWildCards       #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module Models.Item where

import Control.Monad (mzero)
import Data.Aeson
import Data.ByteString (ByteString)
import Data.Profunctor.Product.TH (makeAdaptorAndInstance)
import Data.Text (pack, Text)
import Data.UUID
import GHC.Generics
import Web.HttpApiData (FromHttpApiData, parseUrlPiece, parseHeader)
import qualified Opaleye as O
import qualified Opaleye.Internal.Column as C
{-import Data.Time.Clock (UTCTime)-}

newtype ItemId = ItemId UUID
  deriving (Show, Eq, Generic)

toItemId :: UUID -> ItemId
toItemId = ItemId

fromItemId :: ItemId -> UUID
fromItemId (ItemId x) = x

fromTextItemId :: Text -> Maybe ItemId
fromTextItemId x = case fromText x of
                     Nothing   -> Nothing
                     Just uuid -> Just $ toItemId uuid

fromASCIIBytesItemId :: ByteString -> Maybe ItemId
fromASCIIBytesItemId x = case fromASCIIBytes x of
                     Nothing   -> Nothing
                     Just uuid -> Just $ toItemId uuid

pgItemId :: ItemId -> O.Column O.PGUuid
pgItemId = C.unsafeCoerceColumn . O.pgString . toString . fromItemId

data Item' id name desc vendor {-num most-}
  = Item {
    _itemId          :: id,
    _itemName        :: name,
    _itemDesc        :: desc,
    _itemVendor      :: vendor
    {-_numTimesOrdered :: num,-}
    {-_mostRecentOrder :: most-}
 }

type ItemRead     = Item' ItemId Text Text Text {-Int UTCTime-}
type ItemWrite    = Item' (Maybe ItemId) Text Text Text {-Int (Maybe UTCTime)-}
type ItemColRead  = Item' (O.Column O.PGUuid)
                          (O.Column O.PGText)
                          (O.Column O.PGText)
                          (O.Column O.PGText)
                          {-(O.Column O.PGInt4)-}
                          {-(O.Column O.PGTimestamptz)-}
type ItemColWrite = Item' (Maybe (O.Column O.PGUuid))
                          (O.Column O.PGText)
                          (O.Column O.PGText)
                          (O.Column O.PGText)
                          {-(O.Column O.PGInt4)-}
                          {-(Maybe (O.Column O.PGTimestamptz))-}

instance ToJSON ItemRead where
  toJSON item = object [
    "_itemId"          .= _itemId item,
    "_itemName"        .= _itemName item,
    "_itemDesc"        .= _itemDesc item,
    "_itemVendor"      .= _itemVendor item ]
    {-"_numTimesOrdered" .= _numTimesOrdered item,-}
    {-"_mostRecentOrder" .= _mostRecentOrder item ]-}

instance ToJSON ItemId where
  toJSON = String . pack . show . fromItemId

instance FromJSON ItemId where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing   -> fail "Failed to parse UUID"
      Just uuid -> return $ toItemId uuid

instance FromJSON ItemWrite where
  parseJSON (Object o) = Item <$>
                              o .:? "_itemId"          <*>
                              o .:  "_itemName"        <*>
                              o .:  "_itemDesc"        <*>
                              o .:  "_itemVendor"      {-<*>-}
                              {-o .:  "_numTimesOrdered" <*>-}
                              {-o .:? "_mostRecentOrder"-}
  parseJSON _ = mzero

$(makeAdaptorAndInstance "pItem" ''Item')

itemTable :: O.Table ItemColWrite ItemColRead
itemTable = O.Table "items" (pItem Item { _itemId          = O.optional "id"
                                        , _itemName        = O.required "name"
                                        , _itemDesc        = O.required "description"
                                        , _itemVendor      = O.required "vendor"
                                        {-, _numTimesOrdered = O.required "numTimesOrdered"-}
                                        {-, _mostRecentOrder = O.optional "mostRecentOrder"-}
                                        })

itemToPG :: ItemWrite -> ItemColWrite
itemToPG = pItem Item { _itemId          = const Nothing
                      , _itemName        = O.pgStrictText
                      , _itemDesc        = O.pgStrictText
                      , _itemVendor      = O.pgStrictText
                      {-, _numTimesOrdered = O.pgInt4-}
                      {-, _mostRecentOrder = const Nothing-}
                      }

instance O.QueryRunnerColumnDefault O.PGUuid ItemId where
  queryRunnerColumnDefault =
    O.queryRunnerColumn id ItemId O.queryRunnerColumnDefault

instance FromHttpApiData ItemId where
  parseUrlPiece = maybe (Left "invalid UUID") Right . fromTextItemId
  parseHeader   = maybe (Left "invalid UUID") Right . fromASCIIBytesItemId

