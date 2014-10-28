{-# LANGUAGE OverloadedStrings #-}

module System.Cron.Sched (
 fromString
) where

import Control.Concurrent
import Control.Monad
import Data.Time.Clock
import Data.Attoparsec.Text
import System.Environment
import System.Cron
import System.Cron.Parser

import qualified Data.Text as T

data Sched = Sched {
 _tick :: Int,
 _maxRounds :: Integer,
 _schedule :: CronSchedule
} deriving (Show)

fromString s = parseOnly cronScheduleLooseGranular $ T.pack s
