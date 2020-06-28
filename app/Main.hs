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

dotGHCIDStack = "--command=stack repl --ghc-options='-j' --allow-eval"

dotGHCIDCabal = "--command=cabal v2-repl --ghc-options'-j' --allow-eval"

buildToolconfig = \case
  Stack -> dotGHCIDStack
  Cabal -> dotGHCIDCabal

