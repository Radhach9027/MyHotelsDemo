//  HotelDetailCustomCell.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

class HotelDetailCustomCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var hotelPrice: UITextField!
    @IBOutlet weak var hotelStayDate: UITextField!
    @IBOutlet weak var hotelAddress: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var ratingView: CustomRatingView!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!

    private var imagePicker: ImagePicker?
    private var datePciker = DatePicker()
    private var model = MyHotel()

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.delegate = self
        self.bgImageView.blurImage()
    }
}


extension HotelDetailCustomCell: ModelUpdateProtocol {
    
    func update(modelData: MyHotel, indexPath: IndexPath) {
        self.model = modelData
        self.hotelName.text = modelData.name
        self.hotelAddress.text = modelData.address
        self.hotelPrice.text = modelData.roomPrice
        self.hotelStayDate.text = modelData.stayDate
        self.ratingView.rating = modelData.rating ?? 0.0
        self.changePhotoButton.setImage(UIImage.dataToImage(data: modelData.image), for: .normal)
    }
}

extension HotelDetailCustomCell {
    
    @IBAction func changePhotoButtonPressed(_ sender: UIButton) {
        self.imagePicker = ImagePicker(delegate: self)
        self.imagePicker?.present(from: sender)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let status = validate()
        
        if status.0 == true {
            
            if let objExits = SharedManager.shared.myHotels.firstIndex(where: {$0.id == model.id}) {
                SharedManager.shared.myHotels.remove(at: objExits)
                SharedManager.shared.myHotels.append(model)
            } else {
                SharedManager.shared.myHotels.append(model)
            }
            
            Alert.presentAlert(withTitle: "Success", message: "Hotel details saved successfully...")
        } else {
            Alert.presentAlert(withTitle: "Alert", message: status.1)
        }
    }
    
    func validate() -> (Bool, String?) {
        if self.model.name == nil {
            return (false, "Hotel name is mandatory")
        } else if self.model.rating == nil {
            return (false, "Hotel rating is mandatory")
        } else if self.model.image == nil {
            return (false, "Hotel image is mandatory")
        }
        return (true, nil)
    }
}

extension HotelDetailCustomCell: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, data: Data?) {
        guard let image = image , let data = data else { return }
        self.changePhotoButton.setImage(image, for: .normal)
        self.bgImageView.image = image
        model.image = data
    }
}

extension HotelDetailCustomCell: RatingViewDelegate {
    
    func ratingView(_ ratingView: CustomRatingView, didChangeRating newRating: Float) {
        model.rating = newRating
    }
}

extension HotelDetailCustomCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 3 {
            datePciker.showDatePicker(frame: textField.frame) { [weak self] (date) in
                textField.text = date
                self?.model.stayDate = date
            }
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let result = text.replacingCharacters(in: range, with: string)
        
        switch textField.tag {
            case 1:
                model.name = result
            case 2:
                model.address = result
            case 4:
                model.roomPrice = result
            default:
                break
        }
        return true
    }
}
