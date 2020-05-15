//
//  CardModel.swift
//  Match App
//
//  Created by anastasija.zukova on 11/05/2020.
//  Copyright © 2020 Accenture. All rights reserved.
//

import Foundation

class CardModel {
    func getCard() -> [Card] {
        // Declare an array to store numbers of generated cards
        var generatedNumbersArray = [Int]()
        // declare an array to store generated cards
        var generatedCardsArray = [Card]()
        //randomly generate pairs of  cards
        while generatedNumbersArray.count < 8 {
            //get a random number
            let randomNumber = arc4random_uniform(13) + 1
           
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                print(randomNumber)
                generatedNumbersArray.append(Int(randomNumber))
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
            }
        }
        //return the array
        return generatedCardsArray
    }
}
