//  SharedManager.swift
//  MyHotels
//  Created by radha chilamkurthy on 09/03/21.

import Foundation

class SharedManager {
    
    static var shared = SharedManager()
    private init() {}
    
    var myHotels = [MyHotel]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("HotelListReload"), object: nil)
        }
    }
}
