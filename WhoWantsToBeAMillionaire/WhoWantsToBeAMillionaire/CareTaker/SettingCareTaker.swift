//
//  SettingCareTaker.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import Foundation

/// An object that is responsible for saving and restoring user game level settings
final class SettingCareTaker {

    // MARK: - Private properties

    /// Returns a decoder to restore user data from local storage
    private let decoder: JSONDecoder

    /// Returns an encoder to save user data to local storage
    private let encoder: JSONEncoder

    /// Returns the key by which data is saved and restored
    private let key: String

    // MARK: - Constructions

    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        key = "settings.level"
    }

    // MARK: - Functions

    /// Save game level settings to local storage
    /// - Parameters:
    ///    - scores: Value of difficult game
    func saveSettings(isHardcoreLevel: Bool) {
        do {
            let data = try encoder.encode(isHardcoreLevel)

            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save game error: \(error.localizedDescription)")
        }
    }

    /// Restore game level settings from local storage
    /// - Returns: If it was possible to restore, then it returns an **Bool**, otherwise a false value
    func restoreSettings() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: key) else { return Bool() }

        do {
            return try decoder.decode(Bool.self, from: data)
        } catch {
            print("Level settings not found error: \(error.localizedDescription)")
            return Bool()
        }
    }
}
