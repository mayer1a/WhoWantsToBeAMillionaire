//
//  ScoresCareTaker.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import Foundation

/// An object that is responsible for saving and restoring user data about game results
final class ScoresCareTaker {

    // MARK: - Private properties

    /// Returns a decoder to restore user data from local storage
    private let decoder: JSONDecoder

    /// Returns an encoder to save user data to local storage
    private let encoder: JSONEncoder

    /// Returns the key by which data is saved and restored
    private let key: String

    // MARK: - Constructions

    init() {
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        self.key = "scores"
    }

    // MARK: - Functions

    /// Save game scores to local storage
    /// - Parameters:
    ///    - scores: Array of scores from all past games to save
    func saveScores(scores: [Score]) {
        do {
            let data = try encoder.encode(scores)

            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save game error: \(error.localizedDescription)")
        }
    }

    /// Restore game scores from local storage
    /// - Returns: If it was possible to restore, then it returns an **[Score]**, otherwise an empty array
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
