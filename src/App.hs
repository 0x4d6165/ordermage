{-# LANGUAGE DataKinds #-}

module App where

import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import System.IO
import Api.Main

-- * run app

run :: IO ()
run = do
  let port = 3000
      settings =
        setPort port $
        setBeforeMainLoop (hPutStrLn stderr ("listening on port " ++ show port)) defaultSettings
  runSettings settings =<< mkApp

mkApp :: IO Application
mkApp = return $ serve api server

