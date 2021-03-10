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
        self.hotelRating.rating = modelData.rating ?? 0
        self.ratingLabel.text = "\(modelData.rating ?? 0)"
        self.hotelImage.image = UIImage.dataToImage(data: modelData.image)
        self.favourites.setImage(modelData.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
}

extension HotelsListCustomCell {
    
    @IBAction func favouritesButtonPressed(_ sender: UIButton) {
        
        guard let cell = sender.nearestAncestor(ofType: UITableViewCell.self),
              let tableView = cell.nearestAncestor(ofType: UITableView.self),
              let indexPath = tableView.indexPath(for: cell)
        else { fatalError("No indexpath found from favouritesButtonPressed") }

        var model = SharedManager.shared.myHotels[indexPath.row]

        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            model.isFavourite = true
        } else {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            model.isFavourite = false
        }

        SharedManager.shared.myHotels[indexPath.row] = model
    }
}
