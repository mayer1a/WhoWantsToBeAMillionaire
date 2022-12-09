//
//  Game.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import Foundation

/// An object that is responsible for the game, results and stored an instance of actual game session
///
/// Saves the results of game sessions to the scoreboard.
/// Clears the scoreboard.
/// Processes the results of the game session
final class Game {

    // MARK: - Properties

    /// Returns the shared defaults object.
    ///
    /// If the default shared object does not already exist, it is created with an empty points array initialized
    ///
    /// - Returns:
    ///     The shared defaults object.
    static let shared = Game()

    /// An instance of a game session that exists only during the user's actual game.
    ///
    /// - Warning: When the game ends, the object is destroyed
    var gameSession: GameSession?

    /// User earned points storage
    private(set) var scores: [Score] {
        didSet {
            scoresCareTaker.saveScores(scores: scores)
        }
    }

    /// User game level settings storage
    private(set) var isHardcoreLevel: Bool {
        didSet {
            settingCareTaker.saveSettings(isHardcoreLevel: isHardcoreLevel)
        }
    }

    // MARK: - Private properties

    private let scoresCareTaker = ScoresCareTaker()
    private let settingCareTaker = SettingCareTaker()

    // MARK: - Private constructions

    private init() {
        scores = scoresCareTaker.restoreScores()
        isHardcoreLevel = settingCareTaker.restoreSettings()
    }

    // MARK: - Functions

    /// Add score record to scoreboard
    ///
    /// - Parameters:
    ///     - score: User scores of **Score** type to be added to the scoretable
    func addScoreEntry(_ score: Score) {
        scores.insert(score, at: 0)
    }

    /// Clear scoreboard
    func clearScoresTable() {
        scores = []
    }

    /// Toggle game difficult level
    func toggleGameLevel() {
        isHardcoreLevel.toggle()
    }

    /// Finish the game with the result - win or lose.
    ///
    /// Calculates the earned points and coins of the user depending on the outcome of the game.
    /// Writes the result to the scoreboard and resets the game session
    func didEndGame(with loss: Bool) {
        guard let gameSession = gameSession else { return }

        var coins = Int()

        if loss {
            switch gameSession.correctAnswers {
                case 3..<6: coins = gameSession.coinsRange[gameSession.correctAnswers - 1]
                case 6..<8: coins = gameSession.coinsRange[gameSession.correctAnswers - 1]
                case 8...10: coins = gameSession.coinsRange[gameSession.correctAnswers - 1]
                default: break
            }
        } else {
            coins = gameSession.coinsEarned
        }

        let usedHintsNumber = 3 - gameSession.hintsAvailable.count
        let score = Score(date: Date(),
                          score: gameSession.scores,
                          coins: coins,
                          usedHintsNumber: usedHintsNumber,
                          isHardcoreLevel: isHardcoreLevel)

        addScoreEntry(score)

        self.gameSession = nil
    }
}

