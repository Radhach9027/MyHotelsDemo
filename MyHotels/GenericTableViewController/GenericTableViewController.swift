//  GenericTableViewController.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

import UIKit

final class GenericTableViewController: UITableViewController {
    
    private var grouped: [Int : [GroupedModel]]?
    private var headerHeight: Height = .dynamic
    private var footerHeight: Height = .dynamic
    private var rowHeight: Height = .dynamic
    private var cellSelection: UITableViewCell.SelectionStyle = .none
    private var cellHandler: (UITableViewCell, IndexPath) -> Void
    private var cellTapHandler: (UITableViewCell, IndexPath) -> Void
    private var sectionViewHandler: ((UIView, Int) -> Void)?
    private var refreshHandler:((UIRefreshControl) -> Void)?
    private var swipeToDelete:((UITableView, IndexPath) -> Void)?
    private var cellEditing: Bool = false
    
    //MARK: TableView Intialization
    init(grouped: [Int : [GroupedModel]]?, cellSelection: UITableViewCell.SelectionStyle = .none, style: UITableView.Style = .plain, separatorLine: UITableViewCell.SeparatorStyle = .singleLine, rowHeight: Height = .dynamic, footerHeight: Height = .dynamic, headerheight: Height = .dynamic, cellEditing: Bool = false, refresh: Refresh? = nil, cellHandler: @escaping (UITableViewCell, IndexPath) -> Void, cellTapHandler: @escaping (UITableViewCell, IndexPath) -> Void, refreshHandler: ((UIRefreshControl)-> Void)? = nil, sectionViewHandler:  ((UIView, Int) -> Void)? = nil, swipeToDelete: ((UITableView, IndexPath) -> Void)? = nil) {
        self.grouped = grouped
        self.cellHandler = cellHandler
        self.cellTapHandler = cellTapHandler
        self.cellSelection = cellSelection
        self.refreshHandler = refreshHandler
        self.swipeToDelete = swipeToDelete
        self.cellEditing = cellEditing
        self.rowHeight = rowHeight
        self.headerHeight = headerheight
        self.footerHeight = footerHeight
        self.sectionViewHandler = sectionViewHandler
        super.init(style: style)
        if (style == .grouped) {
            self.tableView.contentInset = UIEdgeInsets(top: -20, left:0, bottom:0, right: 0)
        }
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = separatorLine
        self.tableView.accessibilityIdentifier = "GenericTableViewController"
        registerCell()
        register_Header_Footer()
        if let refresh = refresh {
            addRefreshControl(showRefresh: refresh)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(" GenericTableViewController de-init")
    }
}

//MARK: Register Cells, Header&Footer
private extension GenericTableViewController {
    
    func registerCell() {
        guard let items = grouped else { return }
        
        let _ = items.compactMap({$0.value.forEach({
            if let reuseIdentifier = $0.customCell?.reuseIdentifier {
                tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            } else {
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.Cell.rawValue)
            }
        })})
    }
    
    func register_Header_Footer() {
        guard let items = grouped else { return }
        
        let _ = items.compactMap({$0.value.forEach({
            
            if let header = $0.header {
                tableView.register(UINib(nibName: header.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: header.reuseIdentifier)
            }
            
            if let footer = $0.footer {
                tableView.register(UINib(nibName: footer.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: footer.reuseIdentifier)
            }
        })})
    }
}

//MARK: Refresh Control
extension GenericTableViewController {
    
    enum Refresh {
        case config(messgae: String, tint: UIColor)
    }
    
    func addRefreshControl(showRefresh: Refresh) {
        
        switch showRefresh {
            
            case let .config(message, tint):
                
                let refreshControl = UIRefreshControl.refresh(message, tint)
                
                if #available(iOS 10.0, *) {
                    tableView.refreshControl = refreshControl
                } else {
                    tableView.addSubview(refreshControl)
                }
                refreshControl.addTarget(self, action:#selector(self.handleRefresh(_:)),for: UIControl.Event.valueChanged)
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if let refresh = self.refreshHandler {
            refresh(refreshControl)
        }
    }
}

//MARK: Clean Up
extension GenericTableViewController {
    
    func cleanUp(itemsList: [Int : [GroupedModel]]?) {
        grouped?.removeAll()
        grouped = itemsList
    }
}


//MARK: TableView Datasource Methods
extension GenericTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return grouped?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupedSection = grouped?.filter({$0.key == section}).first?.value.first
        return groupedSection?.rows ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let customCell = grouped?.filter({$0.key == indexPath.section}).first?.value.first?.customCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: customCell.reuseIdentifier, for: indexPath)
            customCell.update(cell: cell, indexPath: indexPath)
            cell.selectionStyle = self.cellSelection
            cellHandler(cell, indexPath)
            
            return cell
        } else {
            
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.Cell.rawValue, for: indexPath)
            defaultCell.textLabel?.numberOfLines = 0
            cellHandler(defaultCell, indexPath)
            
            return defaultCell
        }
    }
}


//MARK: TableView Delegate Methods
extension GenericTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cellTapHandler(cell, indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header =  grouped?.filter({$0.key == section}).first?.value.first?.header, let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuseIdentifier) else {return nil}
        header.update(view: view, section: section)
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = grouped?.filter({$0.key == section}).first?.value.first?.footer, let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.reuseIdentifier) else {return nil}
        footer.update(view: view, section: section)
        sectionViewHandler?(view, section)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = grouped?.filter({$0.key == section}).first?.value.first?.header else { return Row_HeaderFooter_Heights.section_footer_none.rawValue}
        switch self.headerHeight {
            case .dynamic:
                return UITableView.automaticDimension
            case let.require(height):
                return height
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let _ = grouped?.filter({$0.key == section}).first?.value.first?.footer else { return Row_HeaderFooter_Heights.section_footer_none.rawValue}
        switch self.footerHeight {
            case .dynamic:
                return UITableView.automaticDimension
            case let.require(height):
                return height
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = grouped?.filter({$0.key == section}).first?.value.first?.header else { return Row_HeaderFooter_Heights.section_footer_none.rawValue}
        switch self.headerHeight {
            case .dynamic:
                return Row_HeaderFooter_Heights.estimated_section_footer.rawValue
            case let.require(height):
                return height
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard let _ = grouped?.filter({$0.key == section}).first?.value.first?.footer else { return Row_HeaderFooter_Heights.section_footer_none.rawValue}
        switch self.footerHeight {
            case .dynamic:
                return Row_HeaderFooter_Heights.estimated_section_footer.rawValue
            case let.require(height):
                return height
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.rowHeight {
            case .dynamic:
                return UITableView.automaticDimension
            case .require(let height):
                return height
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.rowHeight {
            case .dynamic:
                return UITableView.automaticDimension
            case .require(let height):
                return height
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            swipeToDelete?(tableView, indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.cellEditing
    }
}


//MARK: TableView Scroll Methods
extension GenericTableViewController {
    
    public func scrollToSelectedIndex(indexPath: IndexPath, animated: Bool, position: UITableView.ScrollPosition) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: indexPath, at: position, animated: animated)
        }
    }
    
    public func scrollToNearestIndex(animated: Bool, position: UITableView.ScrollPosition) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToNearestSelectedRow(at: position, animated: animated)
        }
    }
    
    public func scrollToVisibleRect(animated: Bool, rect: CGRect) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollRectToVisible(rect, animated: animated)
        }
    }
}


//MARK: TableView Reload Methods
extension GenericTableViewController {
    
    public func reloadSections(section: Int, grouped: [Int : [GroupedModel]]?) {
        DispatchQueue.main.async { [weak self] in
            self?.cleanUp(itemsList: grouped)
            self?.tableView.beginUpdates()
            self?.tableView.reloadSections(IndexSet(integer: section), with: .none)
            self?.tableView.endUpdates()
        }
    }
    
    public func reloadRows(indexPath: IndexPath, grouped: [Int : [GroupedModel]]?) {
        DispatchQueue.main.async { [weak self] in
            self?.cleanUp(itemsList: grouped)
            self?.tableView.beginUpdates()
            self?.tableView.reloadRows(at:[indexPath], with: .none)
            self?.tableView.endUpdates()
        }
    }
    
    public func reload(grouped: [Int : [GroupedModel]]?) {
        DispatchQueue.main.async { [weak self] in
            self?.cleanUp(itemsList: grouped)
            self?.tableView.reloadData()
        }
    }
    
    public func performBatchUpdates(grouped: [Int : [GroupedModel]]?) {
        self.cleanUp(itemsList: grouped)
        self.tableView.performBatchUpdates({}, completion: nil)
    }
}


//MARK: TableView Row, Header&Footer Height Constraints
enum Row_HeaderFooter_Heights: CGFloat {
    case row = 44.0
    case estimated_section_footer = 25.0
    case section_footer_none = 0.0
}

enum Height {
    case require(height: CGFloat)
    case dynamic
}


//MARK: Collection Default Cell Identifier
enum DefaultCell: String {
    case Cell
}

