{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module User where

import Control.Monad.Trans.Except
import Data.Aeson
import Data.Maybe
import Data.Text.Encoding (encodeUtf8)
import Data.UUID
import GHC.Generics
import Servant
import Text.Email.Validate
import Utils

type UserApi =
  "user" :> Get '[JSON] [User] :<|>
  "user" :> Capture "userId" String :> Get '[JSON] User

userServer :: Server UserApi
userServer =
  getUsers :<|>
  getUserById

getUsers :: Handler [User]
getUsers = return [exampleUser]

getUserById :: String -> Handler User
getUserById = \ case
  (x:xs) -> return exampleUser
  _ -> throwE err404

exampleUser :: User
exampleUser = User (genV5UUID "ordermage-example") "L. Smith" (fromJust (emailAddress "lsmith@example.com")) Base

-- * user info
data UserLevel = Base | Admin
  deriving (Eq, Show, Generic)
instance FromJSON UserLevel

data User
  = User {
    userId :: UUID,
    userName :: String,
    userEmail :: EmailAddress,
    userLevel :: UserLevel
  }
  deriving (Eq, Show, Generic)

instance ToJSON User where
    toJSON (User userId userName userEmail userLevel) =
      object ["userId" .= show userId, "userName" .= userName, "userEmail" .= show userEmail, "userLevel" .= show userLevel]

instance FromJSON UUID where
  parseJSON = withText "UUID" $ \t ->
    case fromText t of
      Nothing -> fail "Failed to parse UUID"
      Just uuid -> return uuid

instance FromJSON EmailAddress where
  parseJSON = withText "EmailAddress" $ \t ->
    case emailAddress $ encodeUtf8 t of
      Nothing -> fail "Failed to parse email address"
      Just email -> return email

instance FromJSON User
