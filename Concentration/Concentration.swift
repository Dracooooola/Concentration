//
//  Concentration.swift
//  Concentration
//
//  Created by Владислав Климов on 26.10.2019.
//  Copyright © 2019 Владислав Климов. All rights reserved.
//

import Foundation

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

struct Concentration {
    private (set) var cards = [Card]()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter{ cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex : Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    var flipCount = 0
    var store = 0
    var timeForChoose: Date?
    
    mutating func chooseCard (as index: Int) {
        assert(cards.indices.contains(index), "Concentration.choosesCard(at: \(index)): choosen index not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    guard let timeInterval = timeForChoose?.timeIntervalSinceNow else { return }
                    let time = -Int(timeInterval)
                    var coefficient = 1
                    
                    switch time {
                    case 0...5:
                        coefficient = 1
                    case 6...10:
                        coefficient = (time / 2)
                    default:
                        coefficient = 1
                    }
                    store += 10 / coefficient
                    print(time)
                    
                    timeForChoose = nil
                } else if cards[matchIndex].isChecked || cards[index].isChecked {
                    store -= 5
                }
                cards[index].isFaceUp = true
                
                cards[matchIndex].isChecked = true
                cards[index].isChecked = true
                
                let cardsNotMatch = cards.indices.filter{ !cards[$0].isMatched }
                if cardsNotMatch.count < 2 {
                    cards[matchIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                }
            } else {
                indexOfOneAndOnlyFaceUpCard = index
                if timeForChoose == nil {
                    timeForChoose = Date()
                }
            }
        }
    }
    
    mutating func resetGame(){
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isChecked = false
        }
        self.flipCount = 0
        self.store = 0
        self.timeForChoose = nil
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
