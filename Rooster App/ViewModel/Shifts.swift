//
//  Shifts.swift
//  Rooster App
//
//  Created by Abdullah on 06/02/2024.
//

import Foundation

public struct Shift: Codable, Hashable {
    let name: String
    let workday: String
    let start_time: String   // Let op de overeenkomst met de JSON-sleutel "start_time"
    let end_time: String     // Let op de overeenkomst met de JSON-sleutel "end_time"
}

