//  HotelsListViewController.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

class HotelsListViewController: UIViewController {
    @IBOutlet weak var placeHolder: UILabel!
    
    fileprivate var manager = SharedManager.shared
    fileprivate var tableView: GenericTableViewController?
    fileprivate lazy var tableModel:(_ model: [MyHotel]) -> [Int : [GroupedModel]] =  { (model) in
        //Prepare Generic custom cell with model
        let cell = ConfigureCollectionsModel<HotelsListCustomCell>(modelData: model)
        
        //Prepare model with cells and headers
        let groupedModel = [GroupedModel(section: 0, rows: model.count, customCell: cell, header: nil)]
        
        //Prepare Section Grouped by grouping with section
        let sectionedGroup = Dictionary(grouping: groupedModel) {$0.section}
        
        return sectionedGroup
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHotelListTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("HotelListReload"), object: nil)
    }
}

extension HotelsListViewController {
    
    func addHotelListTableView() {
        
        let tableModel = self.tableModel(manager.myHotels)
        
        tableView = GenericTableViewController(grouped: tableModel, separatorLine: .none, cellEditing: true, refresh: .config(messgae: "Loading..", tint: .gray), cellHandler: { (cell, indexPath) in
            if let cell = cell as? HotelsListCustomCell {
                cell.favourites.tag = indexPath.row
            }
            print("Cell Rolling")
        }, cellTapHandler: { [weak self] (cell, indexPath) in
            print("Cell Tapped")
            self?.pushToHotelDetail(type: "Edit Hotel", indexPath: indexPath)
        }, refreshHandler: { (refresh) in
            print("RefreshControl Pulled")
            refresh.endRefreshing()
        }, sectionViewHandler: { (header, section) in
            print("Header View")
        }, swipeToDelete: { [weak self] (tableView, indexPath) in
            print("swipeToDelete Tapped")
            self?.manager.myHotels.remove(at: indexPath.row)
        })
        
        add(tableView!)
        addConstraints(someController: tableView)
        checkPlaceHolder()
    }
}

extension HotelsListViewController {
    
    @IBAction func addHotelButtonPressed(_ sender: Any) {
       pushToHotelDetail(type: "Add Hotel")
    }
}

private extension HotelsListViewController {
    
    func pushToHotelDetail(type: String , indexPath: IndexPath? = nil) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        if let controller = story.instantiateViewController(identifier: "HotelsDetailViewController") as? HotelsDetailViewController{
            controller.title = type
            controller.indexPath = indexPath
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    
    @objc func reloadTableView() {
        let tableModel = self.tableModel(manager.myHotels)
        tableView?.reloadSections(section: 0, grouped: tableModel)
        checkPlaceHolder()
    }
    
    func checkPlaceHolder() {
        if manager.myHotels.count > 0 {
            tableView?.tableView.isHidden = false
            self.placeHolder.isHidden = true
        } else {
            tableView?.tableView.isHidden = true
            self.placeHolder.isHidden = false
        }
    }
}


