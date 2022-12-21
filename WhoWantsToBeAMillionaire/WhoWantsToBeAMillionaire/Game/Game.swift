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

    private(set) var questionOrder: QuestionsOrder {
        didSet {
            settingsCareTaker.saveQuestionOrderSettings(questionOrder)
        }
    }

    private(set) var userQuestions: [Question] {
        didSet {
            questionsCareTaker.saveQuestions(userQuestions)
        }
    }

    var difficultyStrategy: DifficultyStrategy {
        switch difficultyLevel {
            case .easy:
                return EasyDifficultyQuestionsStrategy(with: userQuestions)
            case .medium, .hard:
                return MediumDifficultyQuestionsStrategy(with: userQuestions)
        }
    }

    var orderStrategy: QuestionOrderStrategy {
        switch questionOrder {
            case .serial:
                return SeialQuestionsOrderStrategy()
            case .random:
                return RandomQuestionsOrderStrategy()
        }
    }

    // MARK: - Private properties

    private let scoresCareTaker = ScoresCareTaker()
    private let settingsCareTaker = SettingsCareTaker()
    private let questionsCareTaker = QuestionsCareTaker()

    // MARK: - Private constructions

    private init() {
        scores = scoresCareTaker.restoreScores()
        difficultyLevel = settingsCareTaker.restoreDifficultySettings()
        questionOrder = settingsCareTaker.restoreQuestionOrderSettings()
        userQuestions = questionsCareTaker.restoreQuestions()
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

    func setQuestionOrder(with value: QuestionsOrder) {
        questionOrder = value
    }

    func addUsersQuestion(_ questions: [Question]) {
        userQuestions = questions
    }

    func didEndGame(with loss: Bool) {
        guard let gameSession = gameSession else { return }

        var coins = Int()

        if loss {
            switch gameSession.correctAnswers.value {
                case 3..<6: coins = gameSession.coinsRange[gameSession.correctAnswers.value - 1]
                case 6..<8: coins = gameSession.coinsRange[gameSession.correctAnswers.value - 1]
                case 8...10: coins = gameSession.coinsRange[gameSession.correctAnswers.value - 1]
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

