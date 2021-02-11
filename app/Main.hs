module Main where

import Relude
import Relude.File (writeFileText)
import System.Console.CmdArgs ((&=), auto,  cmdArgs, modes)
import Data.Data (Data)
import System.Directory (getCurrentDirectory)
import System.FilePath ((</>))

data BuildTool = Stack | Cabal
  deriving stock (Show, Eq, Ord, Data, Typeable)



main :: IO ()
main = do
  print $ "Version 0.2.0"
  buildTool <- cmdArgs (modes [Stack, Cabal &= auto])
  putStrLn $ "writing ghcid config for " <> show buildTool
  execute buildTool

execute :: BuildTool -> IO ()
execute buildTool = do
  pwd <- getCurrentDirectory
  putStrLn pwd
  putStrLn (pwd </> ".ghci")
  writeFileText (pwd </> ".ghci") dotGHCI
  writeFileText (pwd </> ".ghcid") $ buildToolconfig buildTool
  putStrLn "files written successfully"
  pure ()

dotGHCI = ""



dotGHCIDStack = "--command=\"stack repl \" --allow-eval"

dotGHCIDCabal = "--command=\"cabal new-repl --disable-optimization --repl-options=-fobject-code\" --allow-eval"

buildToolconfig = \case
  Stack -> dotGHCIDStack
  Cabal -> dotGHCIDCabal

