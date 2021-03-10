//  UIImageView+Extensions.swift
//  MyHotels
//  Created by radha chilamkurthy on 10/03/21.

import UIKit

extension UIImageView {
    
    func blurImage(){
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
