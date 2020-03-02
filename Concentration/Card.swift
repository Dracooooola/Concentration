//
//  Card.swift
//  Concentration
//
//  Created by Владислав Климов on 26.10.2019.
//  Copyright © 2019 Владислав Климов. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var isFaceUp = false
    var isMatched = false
    var isChecked = false
    private var identifier = Card.getUniqueIdentifier()
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
