//  UIViewController+Extension.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {return}
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    @discardableResult
    func addConstraints(someController: UIViewController?) -> Bool {
        guard let controller = someController else {return false}
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return true
    }
}
