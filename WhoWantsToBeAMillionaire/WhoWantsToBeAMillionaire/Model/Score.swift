//
//  Score.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import Foundation

/// A codable object that stores data about the user's score for the game
struct Score: Codable {
    let date: Date
    let score: Int
    let coins: Int
    let usedHintsNumber: Int
    let isHardcoreLevel: Bool
}
