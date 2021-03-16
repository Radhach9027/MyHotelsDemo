//  Hotels.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

struct MyHotel: Hashable, Equatable {
    var name: String?
    var address: String?
    var stayDate: String?
    var roomPrice: String?
    var rating: Float = 0.0
    var image: Data?
    var id: UUID = UUID()
    var isFavourite: Bool = false
}
