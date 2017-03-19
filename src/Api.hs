{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api where

import Item
import Order
import Servant
import User

-- * api
type Api = ItemApi :<|>
           UserApi :<|>
           OrderApi

api :: Proxy Api
api = Proxy

server :: Server Api
server = itemServer :<|>
         userServer :<|>
         orderServer
