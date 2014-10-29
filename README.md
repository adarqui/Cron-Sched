Cron-Sched
===

Uses the cron library which has "seconds" and eventually "microseconds" resolution:

https://github.com/adarqui/cron

Original:

https://github.com/MichaelXavier/cron

TODO:
---

Alot todo.. Mainly:
- Synchronize clock the "0th" second & minute
- Add a schedM (collect results from every cb)
- Maybe use async to make sure we 'end gracefully'

Info
---

```
data Sched = Sched {
 _tick :: Int,
 _limit :: Integer,
 _schedule :: CronSchedule
} deriving (Show)
```

sched will create a scheduler that will 'fire' every tick. If the schedule matches, it will fire off a thread for every io action passed in the 'acts' list. If a > 0 limit is supplied, it will be decremented every time there is a schedule match; once it hits 0, sched will return. Passing (-1) for "limit" will cause sched to run forever.

The cron syntax has an added "seconds" cron field:

```
* * * * *
s m hr d mon yr
```

Some library examples:
---

```
sched defaultSecond [print "fi",print "fo",print "fum"]
sched defaultMinute [print "fi",print "fo",print "fum"]
sched (fromRight $ fromString secondTick 10 "* * * * * *") [print "fi",print "fo",print "fum"]
sched (fromRight $ fromString secondTick 5 "*/2 * * * * *") [print "fi",print "fo",print "fum"]
sched (fromRight $ fromString minuteTick 1 "* * * * * *") [print "fi",print "fo",print "fum"]
```

Some quick examples:
---

```
./.cabal-sandbox/bin/exec 1000000 -1 "*/2 * * * * *"
```
