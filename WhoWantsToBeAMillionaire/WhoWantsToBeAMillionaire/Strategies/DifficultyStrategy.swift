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

    func getQuestions() -> [Question] {
        return Question.easyQuestions()
    }
}

final class MediumDifficultyQuestionsStrategy: DifficultyStrategy {

    func getQuestions() -> [Question] {
        return Question.hardcoreQuestions()
    }
}
