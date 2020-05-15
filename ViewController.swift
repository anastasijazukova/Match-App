//
//  ViewController.swift
//  Match App
//
//  Created by anastasija.zukova on 10/05/2020.
//  Copyright © 2020 Accenture. All rights reserved.
//

import UIKit

class ViewController:
UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    
    @IBOutlet weak var TimerLabel: UILabel!
    
    
    @IBOutlet weak var CardCollectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Float = 30 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    var gameCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        //Call the getCard method  of the card model
        CardCollectionView.delegate = self
        CardCollectionView.dataSource = self
        startNewGame()
    }
        //Create timer
        

    func startNewGame() {
        cardArray = model.getCard()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        CardCollectionView.reloadData()
        firstFlippedCardIndex = nil
        milliseconds = 30 * 1000
        
    }
    
    func quitGame() {
        exit(0)
    }
    // MARK: - Timer methods
    @objc func timerElapsed() {
        milliseconds -= 1
        //Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        //Set label
        TimerLabel.text = "Time remaining: \(seconds)"
        //Stop timer at 0
        if milliseconds <= 0 {
            timer?.invalidate()
            TimerLabel.textColor = UIColor.red
            // Check for unmatched cards
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView protocol methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a CardCollectionView object
        let cell = CardCollectionView.dequeueReusableCell(withReuseIdentifier: "Card cell", for: indexPath) as! CardCollectionViewCell
        // Get the card that CollectionView is trying to display
        var card = cardArray[indexPath.row]
        // Set that card for the cell
        cell.setCard(card)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Check if there is any time left
        if milliseconds <= 0 {
            return
        } 
        //Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that user selected
        var card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.ismatched == false {
            //Flip the card
            cell.flipFront()
            //Change the status of the card
            card.isFlipped = true
            //Determine if it's the first of a second flipped card
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                checkForMatches(collectionView, secondFlippedCardIndex: indexPath)           }
        }
        
    } //End of didSelectItemAt method
    
    // MARK: - Game logic
    func checkForMatches(_ collectionView:UICollectionView, secondFlippedCardIndex:IndexPath) {
        //Get the cells for the two cards that have been revealed
        var cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        var cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        //Get the images for the two cards that were revealed
        var cardOne = cardArray[firstFlippedCardIndex!.row]
        var cardTwo = cardArray[secondFlippedCardIndex.row]
        //Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            //It's a match
            
            //Set the satstuses of the cards
            cardOne.ismatched = true
            cardTwo.ismatched = true
            //Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            //Check if there are any cards left unmatched
            checkGameEnded()
            
        } else {
            //It's not a match
            
            //Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            //Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        //Tell collectionView to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        //Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        var isWon = true
        
        //Determine if there are any cards unmatched
        for card in cardArray {
            if card.ismatched == false {
                isWon = false
                break
            }
        }
        //count cards
        let matchedCards = cardArray.filter { card in
            
            return card.ismatched }
        
        let score = matchedCards.count
        
        //Messaging variables
        var title = ""
        var message = ""
        
        //If not, user has won, stop the timer
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You have won!"
        } else {
            //If there are unmatched cards, check, if there is any time left
            if milliseconds > 0 {
                return
            }
            title = "Game over"
            message = "You have lost"
            
        }
        
        
        //Show win/lost message
        showAlert(title, message:message)
    }
    
    //MARK: - Show message method
    func showAlert(_ title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Exit", style: .default, handler: { action in self.quitGame() } )
        let alertAction1 = UIAlertAction(title: "New game", style: .default, handler: { action in self.startNewGame() } )
        alert.addAction(alertAction)
        alert.addAction(alertAction1)
        
        present(alert, animated: true, completion: nil)
    }
    
    
} //End of ViewController class
