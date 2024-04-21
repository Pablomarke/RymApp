//
//  allCharacters.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 28/7/23.
//

import Foundation

struct AllCharacters: Codable {
    let results: Characters
    let info: ApiInfo?
    
    enum CodingKeys: CodingKey {
        case info
        case results
    }
}
