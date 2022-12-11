//
//  GameSession.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import Foundation

enum Hint: Int {
    case fiftyFifty = 0
    case auditoryHelp = 1
    case callFriend = 2
}

final class GameSession {

    // MARK: - Properties

    let coinsRange: [Int] = {
        return [2000, 4000, 8000, 16000, 32000, 64000, 125_000, 250_000, 500_000, 1_000_000]
    }()

    // MARK: - Private properties

    private var correctAnswerCount: Observable<Int>
    private var questionsCount: Int
    private var playerEarnedCoins: Int
    private var scoresEarned: Int
    private var hints: [Hint]

    // MARK: - Constructions

    init() {
        correctAnswerCount = Observable<Int>(Int())
        questionsCount = Int()
        playerEarnedCoins = Int()
        scoresEarned = Int()
        hints = [.fiftyFifty, .callFriend, .auditoryHelp]
    }
}

// MARK: - Extensions

extension GameSession: GameSessionDelegate {

    var totalQuestionsNumber: Int {
        get { return questionsCount }
        set { questionsCount = newValue }
    }

    var correctAnswers: Observable<Int> {
        get { return correctAnswerCount }
    }

    var hintsAvailable: [Hint] {
        get { return hints }
    }

    var coinsEarned: Int {
        get { return playerEarnedCoins }
    }

    var scores: Int {
        get { return scoresEarned }
    }

    func increaseCorrectAnswersNumber() {
        correctAnswerCount.value += 1
        playerEarnedCoins = coinsRange[correctAnswerCount.value - 1]
        scoresEarned = 100 / totalQuestionsNumber * correctAnswerCount.value
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
