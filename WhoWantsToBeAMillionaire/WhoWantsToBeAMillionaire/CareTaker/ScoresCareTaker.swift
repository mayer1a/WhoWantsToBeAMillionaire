//
//  ScoresCareTaker.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import Foundation

final class ScoresCareTaker {

    // MARK: - Private properties

    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let key: String

    // MARK: - Constructions

    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        key = "scores"
    }

    // MARK: - Functions

    func saveScores(scores: [Score]) {
        do {
            let data = try encoder.encode(scores)

            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save game error: \(error.localizedDescription)")
        }
    }

    func restoreScores() -> [Score] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [Score]() }

        do {
            return try decoder.decode([Score].self, from: data)
        } catch {
            print("Game not found error: \(error.localizedDescription)")
            return [Score]()
        }
    }
}
