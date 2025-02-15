//
//  Character.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 27/7/23.
//

import UIKit

typealias Characters = [Character]

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let image: String
    let created: Date
    let species: String
    let gender: String
    var type: String
    let location: SimpleLocation
    let origin: SimpleLocation
    let episode: [String]
}

extension Character {
    func statusColor() -> UIColor {
        if status == "Alive" {
            return .green
        } else if status == "Dead"{
            return .red
        } else {
            return .gray
        }
    }
    
    mutating func typeForVoidString() -> String{
        if type == "" {
            return "---"
        } else {
            return type
        }
    }
}
