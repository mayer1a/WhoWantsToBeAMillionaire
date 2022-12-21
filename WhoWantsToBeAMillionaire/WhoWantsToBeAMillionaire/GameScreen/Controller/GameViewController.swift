//
//  GameViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 04.12.2022.
//

import UIKit

protocol GameSessionDelegate: AnyObject {

    var totalQuestionsNumber: Int { get set }
    var correctAnswers: Observable<Int> { get }
    var hintsAvailable: [Hint] { get }
    var coinsEarned: Int { get }
    var scores: Int { get }
    var currentQuestion: Question {get set }

    func increaseCorrectAnswersNumber()
    func useHint(_ hintIndex: Int)
}

final class GameViewController: UIViewController {

    // MARK: - Properties

    weak var gameSessionDelegate: GameSessionDelegate?

    // MARK: - Private properties

    private var gameView: GameView? {
        return isViewLoaded ? view as? GameView : nil
    }

    private lazy var questions: [Question] = {
        return Game.shared.difficultyStrategy.getQuestions()
    }()

    private lazy var orderedQuestions: [Question] = {
        return Game.shared.orderStrategy.getOrderedQuestions(from: questions)
    }()

    private lazy var currentQuestion: Int = {
        return 0
    }()

    private lazy var isLost: Bool = {
        return false
    }()

    // MARK: - Lifecycle

    override func loadView() {
        view = GameView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Game.shared.gameSession = GameSession(with: questions[currentQuestion], hintUsageFacadeDelegate: self)

        gameView?.delegate = self

        gameSessionDelegate = Game.shared.gameSession.self
        gameSessionDelegate?.totalQuestionsNumber = orderedQuestions.count
        gameSessionDelegate?.correctAnswers.addObserver(self, options: [.initial, .new]) { [weak self] (correctAnswers, _) in

            guard
                let totalQuestionsNumber = self?.gameSessionDelegate?.totalQuestionsNumber,
                let scores = self?.gameSessionDelegate?.scores
            else { return }

            self?.gameView?.questionCounterLabelConfigure(with: (correctAnswers, totalQuestionsNumber, scores))
        }
        
        setupQuestion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Private functions

    private func setupQuestion() {
        guard let gameSession = gameSessionDelegate else { return }

        guard currentQuestion < gameSession.totalQuestionsNumber
        else {
            gameExit()
            return
        }

        let question = orderedQuestions[currentQuestion]
        let newCounterLabelValue = (currentQuestion, gameSession.totalQuestionsNumber, gameSession.scores)

        gameView?.questionLabel.text = question.text
        gameView?.questionCounterLabelConfigure(with: newCounterLabelValue)

        gameSessionDelegate?.currentQuestion = question

        for (index, answer) in question.answers.enumerated() {

            gameView?.answerButtons[index].setTitle(answer.key, for: .normal)
            gameView?.answerButtons[index].updateConstraints()
        }
    }
}

// MARK: - Extensions

extension GameViewController: GameViewDelegate {
    
    func gameExit() {
        Game.shared.didEndGame(with: isLost)

        navigationController?.popViewController(animated: true)
    }
    
    func helpButtonTapped() {
        let helpPageViewController = HelpPageViewController()
        helpPageViewController.delegate = self

        navigationController?.pushViewController(helpPageViewController, animated: true)
    }
    
    func answerButtonTapped(with playerAnswer: String) {
        if gameView?.percentsLabelView.isHidden == false {
            gameView?.percentsLabelView.isHidden = true
        }

        if playerAnswer == orderedQuestions[currentQuestion].correctAnswer {
            gameSessionDelegate?.increaseCorrectAnswersNumber()

            currentQuestion += 1
            setupQuestion()
        } else {
            isLost = true
            gameExit()
        }
    }

    func hintButtonsTapped(with tag: Int) {
        gameSessionDelegate?.useHint(tag)
    }
}

extension GameViewController: GameViewControllerDelegate {

    var hints: [String] {
        get {
            let question = orderedQuestions[currentQuestion]
            return [question.fiftyTofiftyHint, question.auditoryHelpHint, question.callFriendHint]
        }
    }
}

extension GameViewController: HintUsageFacadeDelegate {

    func callFriend(friendAnswer: String) {
        gameView?.percentAnswerLabelCofigure(with: friendAnswer)
    }
    
    func useAuditoryHelp(auditoryAnswer: String) {
        gameView?.percentAnswerLabelCofigure(with: auditoryAnswer)
    }

    func useFiftyFiftyHint(_ answers: [String]) {
        gameView?.answerButtonCofigure(by: answers)
    }
}
