//
//  QuestionsBuilder.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 14.12.2022.
//

import Foundation

enum QuestionBuilderError: Error {
    case buildError(error: String = """
            Build questions failed because the number of questions, answer sets, and correct answers is not equal
            """)
    case answersCountError(error: Int)
}

final class QuestionsBuilder {

    // MARK: - Private properties

    private(set) var questions = [String]()
    private(set) var answers = [[String : Int]]()
    private(set) var correctAnswers = [String]()

    // MARK: - Functions

    func build() throws -> [Question] {
        guard
            questions.count == answers.count,
            questions.count == correctAnswers.count
        else {
            throw QuestionBuilderError.buildError()
        }

        if let errorAnswersIndex = answers.firstIndex(where: {$0.count < 4}) {
            throw QuestionBuilderError.answersCountError(error: errorAnswersIndex)
        }

        let resultQuestions = questions.enumerated().compactMap { question in
            Question(text: question.element,
                     answers: answers[question.offset],
                     correctAnswer: correctAnswers[question.offset])
        }

        return resultQuestions
    }

    func setAnswer(_ answer: String, withProbability probability: Int) {
        if answers.count == 0 || answers.last?.count == 4 {
            answers.append([answer : probability])
        } else {
            answers[answers.count - 1][answer] = probability
        }
    }

    func setQuestion(_ question: String) {
        questions.append(question)
    }

    func setCorrectAnswer(_ correctAnswer: String) {
        correctAnswers.append(correctAnswer)
    }

    func clearBuilder() {
        answers = []
        questions = []
        correctAnswers = []
    }
}
