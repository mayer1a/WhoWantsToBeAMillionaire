//
//  GameViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 04.12.2022.
//

import UIKit

/// The methods and properties used by the object to pass information about progress in the current game session
protocol GameSessionDelegate: AnyObject {

    /// The total number of questions for one gaming session
    var totalQuestionsNumber: Int { get set }

    /// Returns the number of correct user answers within the game session
    var correctAnswers: Int { get }

    /// Returns an array of available hints within the game session
    var hintsAvailable: [Hint] { get }

    /// Returns the number of coins earned by the user within the game session
    var coinsEarned: Int { get }

    /// Returns the number of scores earned by the user within the game session
    var scores: Int { get }

    /// Increases the number of correct user answers by 1 within the game session
    func increaseCorrectAnswersNumber()

    /// Remove used hint from the list of available user hints within the game session
    /// - Parameters:
    ///     - usedHint: The **Hint** type hint that the user used
    func removeUsedHint(of hint: Hint)
}

/// An object responsible for interacting with the game screen
final class GameViewController: UIViewController {

    // MARK: - Properties

    /// The delegate responsible for transmitting the progress of the current game session
    weak var gameSessionDelegate: GameSessionDelegate?

    // MARK: - Private properties

    /// Returns cast view to **GameView** type
    private var gameView: GameView? {
        return isViewLoaded ? self.view as? GameView : nil
    }

    /// Returns an array of questions for the game session
    private lazy var questions: [Question] = {
        return Game.shared.isHardcoreLevel ? Question.hardcoreQuestions() : Question.easyQuestions()
    }()

    /// Returns the number of the current question
    ///
    /// - Note: The first number of the question is **zero**
    private lazy var currentQuestion: Int = {
        return 0
    }()

    /// The value of the state of the end of the game
    ///
    /// If the game is lost (an incorrect answer is given), the state is **true**
    private lazy var isLost: Bool = {
        return false
    }()

    // MARK: - Lifecycle

    override func loadView() {
        self.view = GameView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Game.shared.gameSession = GameSession()

        self.gameSessionDelegate = Game.shared.gameSession.self
        self.gameView?.delegate = self
        self.gameSessionDelegate?.totalQuestionsNumber = questions.count

        self.setupQuestion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Private functions

    /// Setup a new question - configure answer buttons, question label and question counter label
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

    /// Use fifty fifty hint and display result on screen
    private func useFiftyFiftyHint() {
        var counter = 0
        var previouslyNumber = -1

        while counter != 2 {
            let number = Int.random(in: 0...3)
            let userAnswer = self.gameView?.answerButtons[number].titleLabel?.text

            guard
                number != previouslyNumber,
                userAnswer != self.questions[currentQuestion].correctAnswer
            else { continue }

            self.gameView?.answerButtonCofigure(by: number)
            previouslyNumber = number
            counter += 1
        }
    }

    /// Use auditory help hint and display result on screen
    private func useAuditoryHelpHint() {
        var text = String()

        self.gameView?.answerButtons.enumerated().forEach { (index, button) in
            guard
                let answer = button.titleLabel?.text,
                let percent = self.questions[currentQuestion].answers[answer]
            else { return }

            text += "\tЗа \"\(answer)\" --> \(percent)% зала\n"
        }

        text.removeLast(2)

        self.gameView?.percentAnswerLabelCofigure(with: text)
        self.gameView?.percentsLabelView.isHidden = false
    }

    /// Use call friend hint and display result on screen
    ///
    /// Three options for developing hint actions:
    /// 1. "Friend" doesn't know and all two options may be false
    /// 2. "Friend" doubts and one of the options is correct
    /// 3. "Friend" is sure of the answer and his version is the correct answer
    private func useCallFriendHint() {
        let version = Int.random(in: 0..<90)
        var friendAnswer = String()

        switch version {
            case 0..<30:
                friendAnswer = self.getIncorrectFriendAnswer()
            case 30..<60:
                friendAnswer = self.getPartialIncorrectFriendAnswer()
            case 60..<90:
                friendAnswer = self.getFullCorrectFriendAnswer()
            default:
                break
        }

        self.gameView?.percentAnswerLabelCofigure(with: friendAnswer)
        self.gameView?.percentsLabelView.isHidden = false
    }

    /// Returns a possibly completely incorrect friend's answer
    ///
    /// Version #1: "Friend" doesn't know and all two options may be false
    /// - Returns: A string containing a possibly incorrect friend's answer
    private func getIncorrectFriendAnswer() -> String {
        var answers = [String]()

        while answers.count != 2 {
            let number = Int.random(in: 0...3)
            let userAnswer = self.gameView?.answerButtons[number].titleLabel?.text

            guard userAnswer != answers.first else { continue }

            answers.append(userAnswer ?? " ")
        }

        return "Привет! Я не знаю ответа на этот вопрос 🙁\nМожет ответ «\(answers[0])» или «\(answers[1])»"
    }

    /// Returns a partially incorrect friend's answer
    ///
    /// Version #2: "Friend" doubts and one of the options is correct
    /// - Returns: A string containing a friend's answer where one is correct and one is incorrect
    private func getPartialIncorrectFriendAnswer() -> String {
        var incorrectNumber = -1

        while incorrectNumber < 0 {
            let number = Int.random(in: 0...3)
            let userAnswer = self.gameView?.answerButtons[number].titleLabel?.text

            if userAnswer != self.questions[currentQuestion].correctAnswer {
                incorrectNumber = number
            }
        }

        var answers: Set<String> = [self.gameView?.answerButtons[incorrectNumber].titleLabel?.text ?? "",
                                    self.questions[currentQuestion].correctAnswer]

        return "Привет! Я уверен, что это либо «\(answers.popFirst() ?? "")», либо «\(answers.popFirst() ?? "")» 🙂"
    }

    /// Returns a string containing a completely correct friend's answer
    ///
    /// Version #3: "Friend" is sure of the answer and his version is the correct answer
    /// - Returns: A string containing a completely correct friend's answer
    private func getFullCorrectFriendAnswer() -> String {
        let correctAnswer = self.questions[currentQuestion].correctAnswer
        return "Привет! Прямо в точку, я знаю ответ! 😋\nПравильный вариант - это «\(correctAnswer)»"
    }
}

// MARK: - Extensions

extension GameViewController: GameViewDelegate {
    
    func gameExit() {
        Game.shared.didEndGame(with: self.isLost)

        navigationController?.popViewController(animated: true)
    }
    
    func helpButtonTapped() {
        let helpPageViewController = HelpPageViewController()
        helpPageViewController.delegate = self

        navigationController?.pushViewController(helpPageViewController, animated: true)
    }
    
    func answerButtonTapped(with playerAnswer: String) {
        if self.gameView?.percentsLabelView.isHidden == false {
            self.gameView?.percentsLabelView.isHidden = true
        }

        if playerAnswer == questions[currentQuestion].correctAnswer {
            gameSessionDelegate?.increaseCorrectAnswersNumber()

            self.currentQuestion += 1
            self.setupQuestion()
        } else {
            self.isLost = true
            self.gameExit()
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
