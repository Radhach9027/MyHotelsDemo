//  UIViewController+Extension.swift
//  MyHotels
//  Created by radha chilamkurthy on 08/03/21.


import UIKit

extension UIWindow {
    
    static var window: UIWindow? {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate), let window = sceneDelegate.window {
            return window
        }
        return nil
    }
    
    static var topViewController: UIViewController? {
        
        if let nav = window?.rootViewController as? UINavigationController {
            return nav.topViewController
        } else if let tab = window?.rootViewController as? UITabBarController, let selected = tab.selectedViewController {
            return selected
        } else if let presented = window?.rootViewController?.presentedViewController {
            return presented
        }
        return nil
    }
}

