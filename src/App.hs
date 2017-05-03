{-# LANGUAGE DataKinds #-}

module App where

import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import System.IO
import Api.Main
import qualified Database.PostgreSQL.Simple as PGS

-- * run app

run :: IO ()
run = do
  con <- PGS.connect PGS.defaultConnectInfo
          { PGS.connectUser     = "ordermage"
          , PGS.connectPassword = "thisisatest"
          , PGS.connectDatabase = "ordermage"
          }
  let port = 3000
      settings =
        setPort port $
        setBeforeMainLoop (hPutStrLn stderr ("listening on port " ++ show port)) defaultSettings
  runSettings settings =<< mkApp con

mkApp :: PGS.Connection -> IO Application
mkApp con = return $ serve api (server con)

