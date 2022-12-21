//
//  QuestionsCareTaker.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 14.12.2022.
//

import Foundation

final class QuestionsCareTaker {

    // MARK: - Private properties

    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let key: String

    // MARK: - Constructions

    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        key = "questions"
    }

    // MARK: - Functions

    func saveQuestions(_ questions: [Question]) {
        do {
            let data = try encoder.encode(questions)

            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save questions error: \(error.localizedDescription)")
        }
    }

    func restoreQuestions() -> [Question] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [Question]() }

        do {
            return try decoder.decode([Question].self, from: data)
        } catch {
            print("Questions not found error: \(error.localizedDescription)")
            return [Question]()
        }
    }
}
