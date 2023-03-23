//
//  Prompts.swift
//  Scoop
//
//  Created by Richie Sun on 3/22/23.
//

import Foundation

struct Prompt: Codable {
    let id: Int
    let questionName: String
    let questionPlaceholder: String
    let answer: String?
}

struct UserAnswer: Codable {
    let id: Int
    let answer: String
}
