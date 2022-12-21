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

    var hintUsageFacade: HintUsageFacade
    private var nextQuestion: Question

    // MARK: - Constructions

    init(with question: Question, hintUsageFacadeDelegate: HintUsageFacadeDelegate) {
        correctAnswerCount = Observable<Int>(Int())
        questionsCount = Int()
        playerEarnedCoins = Int()
        scoresEarned = Int()
        hints = [.fiftyFifty, .callFriend, .auditoryHelp]
        nextQuestion = question
        hintUsageFacade = HintUsageFacade(currentQuestion: question)
        hintUsageFacade.delegate = hintUsageFacadeDelegate
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

    var currentQuestion: Question {
        get { return nextQuestion }
        set {
            nextQuestion = newValue
            hintUsageFacade.setupNextQuestion(nextQuestion)
        }
    }

    func useHint(_ hintIndex: Int) {
        var removeIndex: Int? = nil

        switch hintIndex {
            case Hint.fiftyFifty.rawValue:
                hintUsageFacade.useFiftyFiftyHint()
                removeIndex = hints.firstIndex(of: Hint.fiftyFifty)
            case Hint.auditoryHelp.rawValue:
                hintUsageFacade.useAuditoryHelp()
                removeIndex = hints.firstIndex(of: Hint.auditoryHelp)
            case Hint.callFriend.rawValue:
                hintUsageFacade.callFriend()
                removeIndex = hints.firstIndex(of: Hint.callFriend)
            default:
                break
        }

        guard let removeIndex = removeIndex else { return }

        hints.remove(at: removeIndex)
    }
    
    func increaseCorrectAnswersNumber() {
        correctAnswerCount.value += 1
        playerEarnedCoins = coinsRange[correctAnswerCount.value - 1]
        scoresEarned = 100 / totalQuestionsNumber * correctAnswerCount.value
    }
    
}
