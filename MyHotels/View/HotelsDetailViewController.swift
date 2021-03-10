//  HotelsDetailViewController.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

class HotelsDetailViewController: UIViewController {
    
    fileprivate var tableView: GenericTableViewController?
    public var indexPath: IndexPath?
    lazy var tableModel:(_ model: [MyHotel]?) -> [Int : [GroupedModel]] =  { (model) in
        //Prepare Generic custom cell with model
        let cell = ConfigureCollectionsModel<HotelDetailCustomCell>(modelData: model)
        
        //Prepare Group model with cells and headers
        let groupedModel = [GroupedModel(section: 0, rows: 1, customCell: cell, header: nil)]
        
        //Prepare Section Grouped by grouping with section
        let sectionedGroup = Dictionary(grouping: groupedModel) {$0.section}
        
        return sectionedGroup
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if title == "Add Hotel" {
            addHotelDeatilsTableView(model: nil)
        } else {
            if let index = indexPath {
                let model = SharedManager.shared.myHotels[index.row]
                addHotelDeatilsTableView(model: [model])
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView = nil
    }
}


extension HotelsDetailViewController {
    
    func addHotelDeatilsTableView(model: [MyHotel]?) {
        
        let tableModel = self.tableModel(model)
        
        tableView = GenericTableViewController(grouped: tableModel, separatorLine: .none, cellHandler: { (cell, indexPath) in
            if let cell = cell as? HotelDetailCustomCell {
                cell.delegate = self
            }
        }, cellTapHandler: { (cell, indexPath) in
        })
        
        add(tableView!)
        addConstraints(someController: tableView)
    }
}

extension HotelsDetailViewController: HotelDetailCustomCellDelegate {
    
    func hotelDataSaved() {
        self.navigationController?.popViewController(animated: true)
    }
}
