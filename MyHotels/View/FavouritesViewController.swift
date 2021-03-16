//  FavouritesViewController.swift
//  MyHotels
//  Created by radha chilamkurthy on 08/03/21.

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var placeHolder: UILabel!
    
    fileprivate var tableView: GenericTableViewController?
    fileprivate var shared = SharedManager.shared
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
        addFavHotelListTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("HotelListReload"), object: nil)
    }
}

extension FavouritesViewController {
    
    func addFavHotelListTableView() {
        
        let tableModel = self.tableModel(shared.myHotels.filter({$0.isFavourite == true}))
        tableView = GenericTableViewController(grouped: tableModel, separatorLine: .none, cellHandler: { (cell, indexPath) in
            if let cell = cell as? HotelsListCustomCell {
                cell.favourites.isHidden = true
            }
        }, cellTapHandler: { (cell, indexPath) in
            print("Cell Tapped")
        })
        
        add(tableView!)
        addConstraints(someController: tableView)
        checkPlaceHolder()
    }
}

private extension FavouritesViewController {
    
    @objc func reloadTableView() {
        let tableModel = self.tableModel(shared.myHotels.filter({$0.isFavourite == true}).sorted(by: {$0.rating > $1.rating}))
        tableView?.reloadSections(section: 0, grouped: tableModel)
        checkPlaceHolder()
    }
    
    func checkPlaceHolder() {
        if shared.myHotels.contains(where: {$0.isFavourite == true}) {
            tableView?.tableView.isHidden = false
            self.placeHolder.isHidden = true
        } else {
            tableView?.tableView.isHidden = true
            self.placeHolder.isHidden = false
        }
    }
}
