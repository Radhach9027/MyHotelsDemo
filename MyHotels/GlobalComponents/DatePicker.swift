//  HotelsListCustomCell.swift
//  MyHotels
//  Created by radha chilamkurthy on 08/03/21.

import UIKit

class DatePicker {
    
    private var datePicker: UIDatePicker?
    
    func showDatePicker(frame: CGRect = .zero, completion: @escaping (_ date: String) -> Void) {
        
        if let controller = UIWindow.topViewController {
            let alert = UIAlertController(title: "Pick Date", message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
            datePicker = UIDatePicker(frame: CGRect(x:0, y:40, width: controller.view.frame.size.width, height: 250))
            datePicker?.datePickerMode = .date
            datePicker?.maximumDate = Date()
            alert.view.addSubview(datePicker!)
            let doneAction = UIAlertAction(title: "Done", style: .destructive) { [weak self] (action) in
                if let dateString = self?.datePicker?.date.dateAndTimetoString(format: .MMMddyyyy) {
                    completion(dateString)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            
            if (UIDevice().userInterfaceIdiom == .pad){
                print("iPad")
                alert.popoverPresentationController?.sourceView = controller.view
                alert.popoverPresentationController?.sourceRect = frame
                controller.present(alert, animated: true, completion: nil)
            } else {
                controller.present(alert, animated: true, completion: nil)
            }
        }
    }
}
