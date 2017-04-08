{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api.Main where

import Api.Item
import Api.Order
import Api.User
import Servant

-- * api
type Api = "item"  :> ItemApi :<|>
           "user"  :> UserApi :<|>
           "order" :> OrderApi

api :: Proxy Api
api = Proxy

server :: Server Api
server = itemServer :<|>
         userServer :<|>
         orderServer
