//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by anastasija.zukova on 11/05/2020.
//  Copyright © 2020 Accenture. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        // Keep track of the card passed in
        self.card = card
        
        if card.ismatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            
            return
        } else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        frontImageView.image = UIImage(named: card.imageName)
        //Determine if the card if face up or face down
        if card.isFlipped == true {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options:[ .transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    func flipFront() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.5, options:[.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.5, options: [.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
        }
    }
    
    func remove() {
        //Remove both IMAGEVIEWS from being visible
               backImageView.alpha = 0
        //Animation
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
       
        
    }
}
