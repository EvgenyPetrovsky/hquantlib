module QuantLib.Cashflows.CashflowFunctions
        ( module QuantLib.Cashflows.CashflowFunctions
        ) where

import Data.List
import QuantLib.Event
import QuantLib.Time.Date

-- Date inspectors

cfCompareDates :: CashFlow->CashFlow->Ordering
cfCompareDates (CashFlow d1 _) (CashFlow d2 _)
                        | d1  > d1      = GT
                        | d1 == d2      = EQ
                        | d1 <  d2      = LT

cfStartDate :: Leg->Date
cfStartDate = cfDate . minimumBy cfCompareDates

cfMaturityDate :: Leg->Date
cfMaturityDate = cfDate . minimumBy cfCompareDates

cfIsExpired :: Leg->Bool->Date->Bool
cfIsExpired leg True date       = all (\x -> evOccuredInclude x date) leg
cfIsExpired leg False date      = all (\x -> evOccured x date) leg

cfPreviousLeg  :: Leg->Bool->Date->Leg
cfPreviousLeg leg True  date = takeWhile (\x -> evOccuredInclude x date) leg
cfPreviousLeg leg False date = takeWhile (\x -> evOccured x date) leg

cfNextLeg  :: Leg->Bool->Date->Leg
cfNextLeg leg True  date = dropWhile (\x -> evOccuredInclude x date) leg
cfNextLeg leg False date = dropWhile (\x -> evOccured x date) leg

cfPrevious :: Leg->Bool->Date->CashFlow
cfPrevious leg include date = last $ cfPreviousLeg leg include date

cfNext :: Leg->Bool->Date->CashFlow
cfNext leg include date= head $ cfNextLeg leg include date

