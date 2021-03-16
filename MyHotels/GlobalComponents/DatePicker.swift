//  HotelsListCustomCell.swift
//  MyHotels
//  Created by radha chilamkurthy on 08/03/21.

import UIKit

class DatePicker {
    
    static func showDatePicker(frame: CGRect = .zero, completion: @escaping (_ date: String) -> Void) {
        
        if let controller = UIWindow.topViewController {
            let alert = UIAlertController(title: "Pick Date", message: nil, preferredStyle: .actionSheet)
            
            let datePicker = UIDatePicker()
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            alert.view.addSubview(datePicker)
            addConstraints(datePicker: datePicker, alert: alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .destructive) { (action) in
                let dateString = datePicker.date.dateAndTimetoString(format: .MMMddyyyy)
                completion(dateString)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            
            if (UIDevice().userInterfaceIdiom == .pad) {
                print("iPad")
                alert.popoverPresentationController?.sourceView = controller.view
                alert.popoverPresentationController?.sourceRect = frame
                controller.present(alert, animated: true, completion: nil)
            } else {
                controller.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private static func addConstraints(datePicker : UIDatePicker, alert: UIAlertController) {
        if #available(iOS 13.4, *){
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .inline
                alert.view.heightAnchor.constraint(equalToConstant: 550).isActive = true
                datePicker.heightAnchor.constraint(equalToConstant: 380).isActive = true
                datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
            } else {
                datePicker.preferredDatePickerStyle = .wheels
                alert.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
                datePicker.heightAnchor.constraint(equalToConstant: 300).isActive = true
            }
        }
        datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor).isActive = true
    }
}
