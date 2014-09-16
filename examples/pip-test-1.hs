module Main (main) where

import Prelude
import Control.Monad (replicateM)
import Data.List (nub, sort)

import Tournament
import Bots

import Pip


pipTest1Players :: [Player]
pipTest1Players = [ 
                   Player "CooperateBot" cooperateBot
                 , Player "DefectBot" defectBot
                 , Player "JusticeBot" justiceBot 
                 , Player "Pip" pipBot
                 , Player "RandomBot" randomBot
                 , Player "SmarterMirrorBot" smarterMirrorBot
                 , Player "TitForTatBot" titForTatBot
                 ]

showMatchScores :: MatchResult -> String
showMatchScores (b1, b2, hist) = " (" ++ (show $ fst scores) ++ ") " ++ " vs " ++ " (" ++ (show $ snd scores) ++ ") "
  where scores = totalScores hist

-- Run a tournament and print it to stdout.
displayTournament2 :: Int -> [Player] -> IO ()
displayTournament2 n [] = putStrLn "No bots."
displayTournament2 n [winner] = putStr "Winner: " >> print winner
displayTournament2 n players = do
    putStrLn "\n<Start round-robin round>\n"
    robin <- runRoundRobin n players
    mapM_ (\x -> putStrLn (showMatchPlayByPlay x) >> putStrLn (showMatchScores x) >> putStrLn "") robin

    let scores = tabulateResults robin
    putStrLn "Scores after this round-robin round:"
    mapM_ print scores >> putStrLn ""

    if (length . nub $ map snd scores) == 1
        then putStrLn "Tie between these bots:" >> print players
        else let remainingBots = eliminateHalf scores in do
            putStrLn "Bots continuing to the next round:"
            print remainingBots >> putStrLn ""
            displayTournament2 n remainingBots


-- Run the example tournament.
main :: IO ()
main = displayTournament2 100 pipTest1Players
