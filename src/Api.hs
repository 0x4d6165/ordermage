{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api where

import Servant
import Item
import User

-- * api
type Api = ItemApi :<|>
           UserApi

api :: Proxy Api
api = Proxy

server :: Server Api
server = itemServer :<|>
         userServer
