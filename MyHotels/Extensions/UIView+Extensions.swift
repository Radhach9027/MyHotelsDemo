//  UIView+Extensions.swift
//  MyHotels
//  Created by radha chilamkurthy on 10/03/21.

import UIKit

extension UIView {
    func nearestAncestor<T>(ofType type: T.Type) -> T? {
        if let me = self as? T { return me }
        return superview?.nearestAncestor(ofType: type)
    }
}
