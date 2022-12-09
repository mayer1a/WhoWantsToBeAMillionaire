//
//  GameViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 04.12.2022.
//

import UIKit

protocol GameSessionDelegate: AnyObject {

    var totalQuestionsNumber: Int { get set }
    var correctAnswers: Int { get }
    var hintsAvailable: [Hint] { get }
    var coinsEarned: Int { get }
    var scores: Int { get }
    func increaseCorrectAnswersNumber()
    func removeUsedHint(of hint: Hint)
}

final class GameViewController: UIViewController {

    // MARK: - Properties

    weak var gameSessionDelegate: GameSessionDelegate?

    // MARK: - Private properties

    private var gameView: GameView? {
        return isViewLoaded ? view as? GameView : nil
    }

    private lazy var questions: [Question] = {
        return Game.shared.isHardcoreLevel ? Question.hardcoreQuestions() : Question.easyQuestions()
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

        Game.shared.gameSession = GameSession()

        gameSessionDelegate = Game.shared.gameSession.self
        gameView?.delegate = self
        gameSessionDelegate?.totalQuestionsNumber = questions.count

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

        let question = questions[currentQuestion]

        gameView?.questionLabel.text = question.text
        gameView?.questionCounterLabelConfigure(with: (currentQuestion, gameSession.totalQuestionsNumber))

        for (index, answer) in question.answers.enumerated() {

            gameView?.answerButtons[index].setTitle(answer.key, for: .normal)
            gameView?.answerButtons[index].updateConstraints()
        }
    }

    private func useFiftyFiftyHint() {
        var counter = 0
        var previouslyNumber = -1

        while counter != 2 {
            let number = Int.random(in: 0...3)
            let userAnswer = gameView?.answerButtons[number].titleLabel?.text

            guard
                number != previouslyNumber,
                userAnswer != questions[currentQuestion].correctAnswer
            else { continue }

            gameView?.answerButtonCofigure(by: number)
            previouslyNumber = number
            counter += 1
        }
    }

    private func useAuditoryHelpHint() {
        var text = String()

        gameView?.answerButtons.enumerated().forEach { (index, button) in
            guard
                let answer = button.titleLabel?.text,
                let percent = questions[currentQuestion].answers[answer]
            else { return }

            text += "\tЗа \"\(answer)\" --> \(percent)% зала\n"
        }

        text.removeLast(2)

        gameView?.percentAnswerLabelCofigure(with: text)
        gameView?.percentsLabelView.isHidden = false
    }

    private func useCallFriendHint() {
        let version = Int.random(in: 0..<90)
        var friendAnswer = String()

        switch version {
            case 0..<30:
                friendAnswer = getIncorrectFriendAnswer()
            case 30..<60:
                friendAnswer = getPartialIncorrectFriendAnswer()
            case 60..<90:
                friendAnswer = getFullCorrectFriendAnswer()
            default:
                break
        }

        gameView?.percentAnswerLabelCofigure(with: friendAnswer)
        gameView?.percentsLabelView.isHidden = false
    }

    private func getIncorrectFriendAnswer() -> String {
        var answers = [String]()

        while answers.count != 2 {
            let number = Int.random(in: 0...3)
            let userAnswer = gameView?.answerButtons[number].titleLabel?.text

            guard userAnswer != answers.first else { continue }

            answers.append(userAnswer ?? " ")
        }

        return "Привет! Я не знаю ответа на этот вопрос 🙁\nМожет ответ «\(answers[0])» или «\(answers[1])»"
    }

    private func getPartialIncorrectFriendAnswer() -> String {
        var incorrectNumber = -1

        while incorrectNumber < 0 {
            let number = Int.random(in: 0...3)
            let userAnswer = gameView?.answerButtons[number].titleLabel?.text

            if userAnswer != questions[currentQuestion].correctAnswer {
                incorrectNumber = number
            }
        }

        var answers: Set<String> = [gameView?.answerButtons[incorrectNumber].titleLabel?.text ?? "",
                                    questions[currentQuestion].correctAnswer]

        return "Привет! Я уверен, что это либо «\(answers.popFirst() ?? "")», либо «\(answers.popFirst() ?? "")» 🙂"
    }

    private func getFullCorrectFriendAnswer() -> String {
        let correctAnswer = questions[currentQuestion].correctAnswer
        return "Привет! Прямо в точку, я знаю ответ! 😋\nПравильный вариант - это «\(correctAnswer)»"
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

        if playerAnswer == questions[currentQuestion].correctAnswer {
            gameSessionDelegate?.increaseCorrectAnswersNumber()

            currentQuestion += 1
            setupQuestion()
        } else {
            isLost = true
            gameExit()
        }
    }

    func hintButtonsTapped(with tag: Int) {
        switch tag {
            case Hint.fiftyFifty.rawValue:
                useFiftyFiftyHint()
                gameSessionDelegate?.removeUsedHint(of: Hint.fiftyFifty)
            case Hint.auditoryHelp.rawValue:
                useAuditoryHelpHint()
                gameSessionDelegate?.removeUsedHint(of: Hint.auditoryHelp)
            case Hint.callFriend.rawValue:
                useCallFriendHint()
                gameSessionDelegate?.removeUsedHint(of: Hint.callFriend)
            default:
                break
        }
    }
}

extension GameViewController: GameViewControllerDelegate {
    
    var hints: [String] {
        get {
            let question = questions[currentQuestion]
            return [question.fiftyTofiftyHint, question.auditoryHelpHint, question.callFriendHint]
        }
    }
}
