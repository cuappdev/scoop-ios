//
//  PhoneFormatter.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/24/22.
//

import UIKit
import Foundation

public class PhoneFormatter {
    
    // MARK: - Properties
    
    private var pattern: String
    private let digit: Character = "#"
    private let alphabetic: Character = "*"
    
    // MARK: - Lifecycle
    
    public init(pattern: String = "###-###-####") {
        self.pattern = pattern
    }
    
    public func formattedString(from plainString: String) -> String {
        guard !pattern.isEmpty else { return plainString }
        
        let pattern: [Character] = Array(self.pattern)
        let allowedCharachters = CharacterSet.alphanumerics
        let filteredInput = String(plainString.unicodeScalars.filter(allowedCharachters.contains))
        let input: [Character] = Array(filteredInput)
        var formatted: [Character] = []
        
        var patternIndex = 0
        var inputIndex = 0
        
        while inputIndex < input.count, patternIndex < pattern.count {
            let inputCharacter = input[inputIndex]
            let allowed: CharacterSet
            
            switch pattern[patternIndex] {
            case digit:
                allowed = .decimalDigits
            case alphabetic:
                allowed = .letters
            default:
                formatted.append(pattern[patternIndex])
                patternIndex += 1
                continue
            }
            
            guard inputCharacter.unicodeScalars.allSatisfy(allowed.contains) else {
                inputIndex += 1
                continue
            }
            
            formatted.append(inputCharacter)
            patternIndex += 1
            inputIndex += 1
        }
        
        return String(formatted)
    }
}
