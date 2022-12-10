//
//  SettingCareTaker.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import Foundation

final class SettingCareTaker {
    
    // MARK: - Private properties
    
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let key: String
    
    // MARK: - Constructions
    
    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        key = "settings.level"
    }
    
    // MARK: - Functions
    
    func saveSettings(isHardcoreLevel: Bool) {
        do {
            let data = try encoder.encode(isHardcoreLevel)
            
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save game error: \(error.localizedDescription)")
        }
    }
    
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
