//  GenericTableViewModel.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

protocol ModelUpdateProtocol: class {
    associatedtype ModelData
    func update(modelData: ModelData, indexPath: IndexPath)
}

protocol RegisterModelType {
    var  reuseIdentifier: String { get }
    func update(cell: UITableViewCell, indexPath: IndexPath)
    func update(view: UIView, section: Int)
}

struct ConfigureCollectionsModel<T> where T: ModelUpdateProtocol {
    var modelData: [T.ModelData]?
    var reuseIdentifier: String = NSStringFromClass(T.self).components(separatedBy: ".").last!
    
    public func update(cell: UITableViewCell, indexPath: IndexPath) {
        if let cell = cell as? T, let model = modelData?[indexPath.row] {
            cell.update(modelData: model, indexPath: indexPath)
        }
    }
    
    public func update(view: UIView, section: Int) {
        if let view = view as? T, let model = modelData?[section] {
            view.update(modelData: model, indexPath: IndexPath(row: 0, section: section))
        }
    }
}

extension ConfigureCollectionsModel: RegisterModelType {}

