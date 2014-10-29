{-# LANGUAGE OverloadedStrings, RecordWildCards #-}

module System.Cron.Sched (
 Sched,
 fromString,
 fromCron,
 sched,
 defaultSecond,
 defaultMinute,
 defaultHour,
 microTick,
 secondTick,
 minuteTick,
 hourTick,
 dayTick,
 monthTick,
 yearTick,
 System.Cron.Sched.parse
) where

import Control.Concurrent
import Data.Time.Clock
import Data.Attoparsec.Text
import Data.Either.Unwrap
import System.Cron
import System.Cron.Parser

import qualified Data.Text as T

data Sched = Sched {
 _tick :: Int,
 _limit :: Integer,
 _schedule :: CronSchedule
} deriving (Show)

fromString :: Int -> Integer -> String -> Either String Sched
fromString tick limit s =
 case cron of
  (Left err) -> Left err
  (Right cron') -> Right $ fromCron tick limit cron'
 where cron = parseOnly cronScheduleLooseGranular $ T.pack s

fromCron :: Int -> Integer -> CronSchedule -> Sched
fromCron tick limit cron =
 Sched {
  _tick = tick,
  _limit = limit,
  _schedule = cron
 }

-- Need to clean this up..
sched :: Sched -> [IO ()] -> IO ()
sched sch@Sched{..} acts = sched' _limit sch acts

sched' :: Integer -> Sched -> [IO ()] -> IO ()
sched' limit sch@Sched{..} acts = do
 now <- getCurrentTime
 limit' <- if (scheduleMatches _schedule now)
  then do
   mapM_ (\act -> forkIO act) acts
   return $ limit - 1
  else return limit
 case (limit' == 0) of
  True -> return ()
  False -> do
   threadDelay _tick
   sched' limit' sch acts

defaultSecond :: Sched
defaultSecond = fromRight $ fromString secondTick (-1) "* * * * * *"

defaultMinute :: Sched
defaultMinute = fromRight $ fromString secondTick (-1) "0 * * * * *"

defaultHour :: Sched
defaultHour = fromRight $ fromString minuteTick (-1) "0 0 * * * *"

microTick :: Int
microTick = 100000

secondTick :: Int
secondTick = (microTick * 10)

minuteTick :: Int
minuteTick = (secondTick * 60)

hourTick :: Int
hourTick = (minuteTick * 60)

dayTick :: Int
dayTick = (hourTick * 24)

monthTick :: Int
monthTick = (dayTick * 30)

yearTick :: Int
yearTick = (monthTick * 12)

parse :: T.Text -> Either String CronSchedule
parse = parseOnly cronScheduleLooseGranular 
