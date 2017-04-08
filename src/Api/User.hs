{-# LANGUAGE DataKinds #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Api.User where

import Control.Monad.Trans.Except
import Data.Maybe
import Models.User
import Servant
import Text.Email.Validate
import Utils

type UserApi =
  Get '[JSON] [User] :<|>
  Capture "userId" String :> Get '[JSON] User

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
exampleUser = User (toUserId  $ genV5UUID "ordermage-example") "L. Smith" (toUserEmail $fromJust (emailAddress "lsmith@example.com")) Base
