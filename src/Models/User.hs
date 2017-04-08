{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Models.User where

import Data.Aeson
import Data.Text
import Data.Text.Encoding (encodeUtf8)
import Data.UUID
import GHC.Generics
import Text.Email.Validate

-- * user info
data UserLevel = Base | Admin
  deriving (Eq, Show, Generic)
instance FromJSON UserLevel

newtype UserId = UserId UUID
  deriving (Eq, Show, Generic)

toUserId :: UUID -> UserId
toUserId = UserId

newtype UserEmail = UserEmail EmailAddress
  deriving (Eq, Show, Generic)

toUserEmail :: EmailAddress -> UserEmail
toUserEmail = UserEmail

data User
  = User {
    userId    :: UserId,
    userName  :: Text,
    userEmail :: UserEmail,
    userLevel :: UserLevel
  }
  deriving (Eq, Show, Generic)

instance ToJSON User where
  toJSON User{..} = object [
    "userId"    .= show userId,
    "userName"  .= userName,
    "userEmail" .= show userEmail,
    "userLevel" .= show userLevel ]

instance FromJSON UserId where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return $ toUserId uuid

instance FromJSON UserEmail where
  parseJSON = withText "EmailAddress" $ \t ->
    case emailAddress $ encodeUtf8 t of
      Nothing -> fail "Failed to parse email address"
      Just email -> return $ toUserEmail email

instance FromJSON User
