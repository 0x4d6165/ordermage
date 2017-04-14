{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api.Main where

import Api.Item
import Api.Order
import Api.User
import Servant
import Database.PostgreSQL.Simple (Connection)

-- * api
type Api = "item"  :> ItemApi :<|>
           "user"  :> UserApi :<|>
           "order" :> OrderApi

api :: Proxy Api
api = Proxy

server :: Connection -> Server Api
server con = itemServer con :<|>
             userServer     :<|>
             orderServer
