//
//  Score.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import Foundation

struct Score: Codable {
    let date: Date
    let score: Int
    let coins: Int
    let usedHintsNumber: Int
    let isHardcoreLevel: Bool
}
