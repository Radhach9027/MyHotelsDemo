//  HotelsListCustomCell.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

class HotelsListCustomCell: UITableViewCell {
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelRating: CustomRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var favourites: UIButton!
}

extension HotelsListCustomCell: ModelUpdateProtocol {
    
    func update(modelData: MyHotel, indexPath: IndexPath) {
        self.hotelName.text = modelData.name
        self.hotelRating.rating = modelData.rating
        self.ratingLabel.text = "\(modelData.rating)"
        self.hotelImage.image = UIImage.dataToImage(data: modelData.image)
        self.favourites.setImage(modelData.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
}

extension HotelsListCustomCell {
    
    @IBAction func favouritesButtonPressed(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "heart") {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            SharedManager.shared.myHotels[sender.tag].isFavourite = true
        } else {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            SharedManager.shared.myHotels[sender.tag].isFavourite = false
        }
    }
}
