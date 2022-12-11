//
//  SettingCareTaker.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import Foundation

final class SettingsCareTaker {

    // MARK: - Private properties
    
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let difficultyLevelKey = "settings.level"
    private let questionOrderKey = "settings.order"
    
    // MARK: - Constructions
    
    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
    }
    
    // MARK: - Functions
    
    func saveDifficultySettings(_ value: GameDifficulty) {
        do {
            let data = try encoder.encode(value)
            
            UserDefaults.standard.set(data, forKey: difficultyLevelKey)
        } catch {
            print("Save game error: \(error.localizedDescription)")
        }
    }

    func saveQuestionOrderSettings (_ value: Int) {
        do {
            let data = try encoder.encode(value)

            UserDefaults.standard.set(data, forKey: questionOrderKey)
        } catch {
            print("Save game error: \(error.localizedDescription)")
        }
    }
    
    func restoreDifficultySettings() -> GameDifficulty {
        guard let data = UserDefaults.standard.data(forKey: difficultyLevelKey) else { return .easy }
        
        do {
            return try decoder.decode(GameDifficulty.self, from: data)
        } catch {
            print("Level settings not found error: \(error.localizedDescription)")
            return .easy
        }
    }

    func restoreQuestionOrderSettings() -> Int {
        guard let data = UserDefaults.standard.data(forKey: questionOrderKey) else { return 0 }

        do {
            return try decoder.decode(Int.self, from: data)
        } catch {
            print("Level settings not found error: \(error.localizedDescription)")
            return 0
        }
    }
}
