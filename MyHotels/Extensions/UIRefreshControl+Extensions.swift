//  UIRefreshControl+Extensions.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

extension UIRefreshControl {
    
    static var refresh: (_ title: String, _ tint: UIColor) -> UIRefreshControl = { (message, tint) in
        let refreshControl = UIRefreshControl()
        let attributedTitle = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor : tint])
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = tint
        refreshControl.accessibilityIdentifier = "RefreshControl"
        return refreshControl
    }
}
