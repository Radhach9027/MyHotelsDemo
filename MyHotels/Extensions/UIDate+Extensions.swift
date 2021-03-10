//  UIDate+Extensions.swift
//  MyHotels
//  Created by radha chilamkurthy on 10/03/21.

import Foundation

extension Date {
    
    enum DateFormats: String {
        case MMMddyyyy = "MMMM dd, yyyy"
    }
    
    func dateAndTimetoString(format: DateFormats) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
