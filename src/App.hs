{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module App where

import Network.Wai
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
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

appCors :: Middleware
appCors = cors $ const (Just appResourcePolicy)


appResourcePolicy :: CorsResourcePolicy
appResourcePolicy =
    CorsResourcePolicy
        { corsOrigins = Nothing -- gives you /*
        , corsMethods = ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTION"]
        , corsRequestHeaders = simpleHeaders -- adds "Content-Type" to defaults
        , corsExposedHeaders = Nothing
        , corsMaxAge = Nothing
        , corsVaryOrigin = False
        , corsRequireOrigin = False
        , corsIgnoreFailures = False
        }



mkApp :: PGS.Connection -> IO Application
mkApp con = return $ appCors (serve api (server con))

