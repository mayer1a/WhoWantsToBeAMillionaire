//
//  Game.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import Foundation

final class Game {

    // MARK: - Properties

    static let shared = Game()

    var gameSession: GameSession?

    private(set) var scores: [Score] {
        didSet {
            scoresCareTaker.saveScores(scores: scores)
        }
    }

    private(set) var difficultyLevel: GameDifficulty {
        didSet {
            settingsCareTaker.saveDifficultySettings(difficultyLevel)
        }
    }

    private(set) var questionOrder: Int {
        didSet {
            settingsCareTaker.saveQuestionOrderSettings(questionOrder)
        }
    }

    var difficultyStrategy: DifficultyStrategy {
        switch difficultyLevel {
            case .easy:
                return EasyDifficultyQuestionsStrategy()
            case .medium, .hard:
                return MediumDifficultyQuestionsStrategy()
        }
    }

    // MARK: - Private properties

    private let scoresCareTaker = ScoresCareTaker()
    private let settingsCareTaker = SettingsCareTaker()

    // MARK: - Private constructions

    private init() {
        scores = scoresCareTaker.restoreScores()
        difficultyLevel = settingsCareTaker.restoreDifficultySettings()
        questionOrder = settingsCareTaker.restoreQuestionOrderSettings()
    }

    // MARK: - Functions

    func addScoreEntry(_ score: Score) {
        scores.insert(score, at: 0)
    }

    func clearScoresTable() {
        scores = []
    }

    func setDifficultyStrategy(with difficulty: GameDifficulty) {
        difficultyLevel = difficulty
    }

    func setQuestionOrder(with value: Int) {
        questionOrder = value
    }

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
                          difficultyLevel: difficultyLevel)

        addScoreEntry(score)

        self.gameSession = nil
    }
}

