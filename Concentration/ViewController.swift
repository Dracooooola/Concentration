//
//  ViewController.swift
//  Concentration
//
//  Created by Владислав Климов on 23.10.2019.
//  Copyright © 2019 Владислав Климов. All rights reserved.
//

import UIKit

extension Int {
    var arc4random: Int {
        if self != 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

class ViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards )
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
                       .strokeWidth: 5.0,
                       .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    func updateStoreLabel() {
        storeLabel.text = "Store: \(game.store)"
    }
    
    private let emojiThemes: [String: (String, UIColor, UIColor)] = [
        "Helloween": ("🎃👻😈🥶🤮👹☠️💀🧠🧟‍♂️🧟‍♀️🦇", #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        "Fruits": ("🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑🥭🍍🥥🥝", #colorLiteral(red: 1, green: 0.7659140209, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)),
        "Cars": ("🚗🚕🚙🚎🏎🚓🚒🚐🚛🚔🚍🚖🚘", #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        "Flags": ("🏳️🏴‍☠️🇦🇺🇦🇱🇦🇽🇦🇿🇦🇹🇦🇸🇦🇮🇦🇴🇦🇩🇧🇾🇧🇯🇧🇲🇨🇦🇷🇺", #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)),
        "People": ("👮🏻‍♂️👷🏻‍♀️👨🏻‍⚕️👩🏼‍🎓👨🏻‍💻👨🏻‍🚀🤴🏻👨🏻‍🏫🧕🏿👳🏻‍♀️👲🏻👵🏻", #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),
    ]
    private var emojiChoices: String?
    private var backgroundColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private var buttonsColor: UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    
    private var emoji = Dictionary<Card, String>()
    
    override func viewDidLoad() {
           super.viewDidLoad()
           chooseTheme()
       }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBOutlet weak var storeLabel: UILabel! {
        didSet{
            updateStoreLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let cardNumber = cardButtons.firstIndex(of: sender) else { return }
        game.chooseCard(as: cardNumber)
        updateViewFromModel()
    }
    @IBAction func newGame(_ sender: UIButton) {
        game.resetGame()
        emojiChoices = nil
        chooseTheme()
        updateViewFromModel()
        emoji = Dictionary<Card, String>()
    }
    
    
    private func chooseTheme () {
        if emojiChoices == nil, let emojiTheme = emojiThemes[Array(emojiThemes.keys)[emojiThemes.keys.count.arc4random]] {
            emojiChoices = emojiTheme.0
            print(emojiChoices!)
            backgroundColor =  emojiTheme.2
            buttonsColor = emojiTheme.1
            for item in cardButtons {
                item.backgroundColor = buttonsColor
            }
            view.backgroundColor = backgroundColor
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices != nil, emojiChoices!.count > 0 {
            let randomStringIndex = emojiChoices!.index(emojiChoices!.startIndex, offsetBy: emojiChoices!.count.arc4random)
            emoji[card] = String(emojiChoices!.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?" // равнносильно if card.indentifier != nil return emoji[card....
    }
    
    private func updateViewFromModel() {
        updateStoreLabel()
        updateFlipCountLabel()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : buttonsColor
            }
        }
    }

}

