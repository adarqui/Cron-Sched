import System.Cron.Sched
import System.Environment

main :: IO ()
main = do
 argv <- getArgs
 case argv of
  (pause:limit:schedule:[]) -> do
   case (fromString (read pause :: Int) (read limit :: Integer) schedule) of
    (Left err) -> error $ "Invalid cron syntax: " ++ err
    (Right schedule) -> do
     sched schedule [putStrLn "ping", putStrLn "pong"]
