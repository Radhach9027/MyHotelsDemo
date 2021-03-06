//  HotelsListCustomCell.swift
//  MyHotels
//  Created by radha chilamkurthy on 08/03/21.

import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, data: Data?)
}   

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController? = UIWindow.topViewController
    private weak var delegate: ImagePickerDelegate?
    
    public init(delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let camera = self.action(for: .camera, title: "Camera") {
            alertController.addAction(camera)
        }
        
        if let library = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(library)
        }
        
        if let albums = self.action(for: .savedPhotosAlbum, title: "Album") {
            alertController.addAction(albums)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        } else {
            self.presentationController?.present(alertController, animated: true)
        }
    }
}

private extension ImagePicker {
    
    func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {return nil}
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image, data: image?.jpegData(compressionQuality: 0.2))
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return self.pickerController(picker, didSelect: nil) }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {}
