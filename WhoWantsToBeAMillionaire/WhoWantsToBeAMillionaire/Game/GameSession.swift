//
//  GameSession.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import Foundation

/// An object that provides user hints types
enum Hint: Int {
    case fiftyFifty = 0
    case auditoryHelp = 1
    case callFriend = 2
}

/// An object that is responsible for the current game session data
final class GameSession {

    // MARK: - Properties

    /// Returns an array of user coin values based on the number of correct answers
    let coinsRange: [Int] = {
        return [2000, 4000, 8000, 16000, 32000, 64000, 125_000, 250_000, 500_000, 1_000_000]
    }()

    // MARK: - Private properties

    /// The number of correct user answers within the game session
    private var correctAnswerCount: Int

    /// The total number of questions for one gaming session
    private var questionsCount: Int

    /// Coins earned by the user during the game session
    private var playerEarnedCoins: Int

    /// Scores earned by the user during the game session
    private var scoresEarned: Int

    /// An array of available hints within the game session
    private var hints: [Hint]

    // MARK: - Constructions

    init() {
        self.correctAnswerCount = Int()
        self.questionsCount = Int()
        self.playerEarnedCoins = Int()
        self.scoresEarned = Int()
        self.hints = [.fiftyFifty, .callFriend, .auditoryHelp]
    }
}

// MARK: - Extensions

extension GameSession: GameSessionDelegate {

    var totalQuestionsNumber: Int {
        get { return self.questionsCount }
        set { self.questionsCount = newValue }
    }

    var correctAnswers: Int {
        get { return self.correctAnswerCount }
    }

    var hintsAvailable: [Hint] {
        get { return self.hints }
    }

    var coinsEarned: Int {
        get { return self.playerEarnedCoins }
    }

    var scores: Int {
        get { return self.scoresEarned }
    }

    func increaseCorrectAnswersNumber() {
        self.correctAnswerCount += 1
        self.playerEarnedCoins = coinsRange[self.correctAnswerCount - 1]
        self.scoresEarned = 100 / self.totalQuestionsNumber * self.correctAnswerCount
    }

    func removeUsedHint(of usedHint: Hint) {
        hints.enumerated().forEach { (index, hint) in
            if hint == usedHint {
                hints.remove(at: index)
                return
            }
        }
    }
    
}
