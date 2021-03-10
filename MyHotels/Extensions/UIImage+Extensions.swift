//  UIImage+Extensions.swift
//  MyHotels
//  Created by radha chilamkurthy on 09/03/21.

import UIKit

extension UIImage {
    
    static func dataToImage(data: Data?) -> UIImage? {
        guard let data = data, let image = UIImage(data: data) else {return nil}
        return image
    }
}
