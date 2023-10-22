//
//  Prompts.swift
//  Scoop
//
//  Created by Richie Sun on 3/22/23.
//

import Foundation

struct Prompt: Codable {
    let id: Int
    let questionName: PromptQuestion
    let questionPlaceholder: String
    let answer: String?
}

class UserAnswer: Codable {
    let id: Int
    var answer: String
    
    init(id: Int, answer: String) {
        self.id = id
        self.answer = answer
    }
}

enum PromptQuestion: String, Codable {
    case hometown = "Hometown"
    case music = "Music"
    case song = "Song"
    case snack = "Snack"
    case stop = "Stop"
    case talkative = "Talkative"
}
