//
//  GameHintsFacade.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 15.12.2022.
//

import Foundation

protocol HintUsageFacadeDelegate: AnyObject {
    func callFriend(friendAnswer: String)
    func useAuditoryHelp(auditoryAnswer: String)
    func useFiftyFiftyHint(_ buttonsNumber: [String])
}

final class HintUsageFacade {

    weak var delegate: HintUsageFacadeDelegate?

    private var currentQuestion: Question

    init(currentQuestion: Question) {
        self.currentQuestion = currentQuestion
    }

    func callFriend() {
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

        delegate?.callFriend(friendAnswer: friendAnswer)
    }

    func useAuditoryHelp() {
        var text = String()

        currentQuestion.answers.forEach { answer in
            text += "\tЗа \"\(answer.key)\" --> \(answer.value)% зала\n"
        }

        text.removeLast(2)

        delegate?.useAuditoryHelp(auditoryAnswer: text)
    }

    func useFiftyFiftyHint() {
        var counter = 0
        var previouslyNumber = -1
        var answers = [String]()

        while counter != 2 {
            let number = Int.random(in: 0...3)
            let userAnswer = currentQuestion.answers.enumerated().first(where: { $0.offset == number })?.element.key

            guard
                let answer = userAnswer,
                number != previouslyNumber,
                answer != currentQuestion.correctAnswer
            else { continue }

            answers.append(answer)
            previouslyNumber = number
            counter += 1
        }

        delegate?.useFiftyFiftyHint(answers)
    }

    func setupNextQuestion(_ question: Question) {
        currentQuestion = question
    }

    // MARK: - Private functions

    private func getIncorrectFriendAnswer() -> String {
        var answers = [String]()

        while answers.count != 2 {
            let number = Int.random(in: 0...3)
            let userAnswer = currentQuestion.answers.enumerated().first(where: { $0.offset == number })?.element.key

            guard userAnswer != answers.first else { continue }

            answers.append(userAnswer ?? " ")
        }

        return "Привет! Я не знаю ответа на этот вопрос 🙁\nМожет ответ «\(answers[0])» или «\(answers[1])»"
    }

    private func getPartialIncorrectFriendAnswer() -> String {
        var answers = [String]()

        while answers.count < 1 {
            let number = Int.random(in: 0...3)
            let userAnswer = currentQuestion.answers.enumerated().first(where: { $0.offset == number })?.element.key

            if userAnswer != currentQuestion.correctAnswer {
                answers = [userAnswer ?? "", currentQuestion.correctAnswer]
            }
        }

        return "Привет! Я уверен, что это либо «\(answers.removeFirst())», либо «\(answers.removeFirst())» 🙂"
    }

    private func getFullCorrectFriendAnswer() -> String {
        let correctAnswer = currentQuestion.correctAnswer
        return "Привет! Прямо в точку, я знаю ответ! 😋\nПравильный вариант - это «\(correctAnswer)»"
    }
    
}
