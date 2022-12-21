//
//  QuestionOrderStrategy.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 11.12.2022.
//

import Foundation

protocol QuestionOrderStrategy: Codable {
    func getOrderedQuestions(from questions: [Question]) -> [Question]
}

final class SeialQuestionsOrderStrategy: QuestionOrderStrategy {

    func getOrderedQuestions(from questions: [Question]) -> [Question] {
        return questions
    }
}

final class RandomQuestionsOrderStrategy: QuestionOrderStrategy {

    func getOrderedQuestions(from questions: [Question]) -> [Question] {
        return questions.shuffled()
    }
}

