//
//  DiffucultyStrategy.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 11.12.2022.
//

import Foundation

protocol DifficultyStrategy: Codable {
    func getQuestions() -> [Question]
}

final class EasyDifficultyQuestionsStrategy: DifficultyStrategy {

    // MARK: - Private properties

    let restoredUserQuestions: [Question]

    // MARK: - Construction

    init(with userQuestions: [Question]) {
        restoredUserQuestions = userQuestions
    }

    // MARK: - Functions

    func getQuestions() -> [Question] {
        let userQuestionsNumber = Int.random(in: 0...restoredUserQuestions.count)
        let easyQuestions = Question.easyQuestions()
        let preparedQuestions = easyQuestions.prefix(easyQuestions.count - userQuestionsNumber)
        let userQuestions = restoredUserQuestions.prefix(userQuestionsNumber)

        let resultQuestions = Array(preparedQuestions + userQuestions)

        return resultQuestions
    }
}

final class MediumDifficultyQuestionsStrategy: DifficultyStrategy {

    // MARK: - Private properties

    let restoredUserQuestions: [Question]

    // MARK: - Construction

    init(with userQuestions: [Question]) {
        restoredUserQuestions = userQuestions
    }

    // MARK: - Functions

    func getQuestions() -> [Question] {
        let userQuestionsNumber = Int.random(in: 0...restoredUserQuestions.count)
        let easyQuestions = Question.hardcoreQuestions()
        let preparedQuestions = easyQuestions.prefix(easyQuestions.count - userQuestionsNumber)
        let userQuestions = restoredUserQuestions.prefix(userQuestionsNumber)

        let resultQuestions = Array(preparedQuestions + userQuestions)

        return resultQuestions
    }
}
