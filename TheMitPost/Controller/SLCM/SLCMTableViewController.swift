//
//  SLCMTableViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 20/05/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import FoldingCell


class SLCMTableViewController: UITableViewController {
    
    var subjects = [Subject]()
    var cellsAnimated = Array<Bool>()
    
    lazy var cellHeights = (0..<subjects.count).map{_ in Cell.CellHeight.cellClose}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()

        setup()
        print("View loaded..")
        print(subjects.count)
        
        // SET UP ALL VARIABLES
        cellsAnimated = Array(repeating: false, count: subjects.count)
        
    }
    
    //MARK: UI THEME
    func mode() {
        
        if traitCollection.userInterfaceStyle == .dark {
            
            self.navigationController?.navigationBar.barTintColor = .background
            
            self.view.backgroundColor = .background
            
        } else {
            self.navigationController?.navigationBar.barTintColor = .systemOrange
            
            self.view.backgroundColor = .white
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
       mode()
    }
    
    //MARK:- HELPERS
    func setup() {
        
        cellHeights = Array(repeating: Cell.CellHeight.cellClose, count: subjects.count)
        
        if traitCollection.userInterfaceStyle == .dark {
            tableView.backgroundColor = .black
        } else {
            //tableView.backgroundColor = UIColor(patternImage: UIImage(named: "slcm_background_2")!)
        }
    
       // tableView.separatorStyle = .none
        tableView.separatorColor = .lightGray
        tableView.estimatedRowHeight = Cell.CellHeight.cellClose
        tableView.rowHeight = UITableView.automaticDimension
        
//        if #available(iOS 10.0, *) {
//            tableView.refreshControl = UIRefreshControl()
//            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
//        }
    }
    
//    @objc func refreshHandler() {
//
//        let deadlineTime = DispatchTime.now() + .seconds(1)
//
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
//            if #available(iOS 10.0, *) {
//                self?.tableView.refreshControl?.endRefreshing()
//            }
//            self?.tableView.reloadData()
//        })
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjects.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard case let cell as SubjectCellTableViewCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        
        let cellIsCollapsed = cellHeights[indexPath.row] == Cell.CellHeight.cellClose
        
        if cellIsCollapsed {
            
            cellHeights[indexPath.row] = Cell.CellHeight.cellOpen
            cell.unfold(true, animated: true, completion: nil)
          
            duration = 0.5
            
            
        } else {
            cellHeights[indexPath.row] = Cell.CellHeight.cellClose
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.9
            
           
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .allowUserInteraction, animations: {() -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }) { (true) in
            print("Finished unfolding..")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if case let cell as FoldingCell = cell {
            
            if cellHeights[indexPath.row] == Cell.CellHeight.cellClose {
                cell.unfold(false, animated: false, completion: nil)
                
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
            
            //
        }
        
        if !cellsAnimated[indexPath.row] {
            animateCellsIntoView(cell: cell)
            cellsAnimated[indexPath.row] = true
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectCellTableViewCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations

        // Configure the cell...
        cell.subject = subjects[indexPath.row]

        return cell
    }
    
    
    fileprivate struct Cell {
        
        struct CellHeight {
            static let cellClose: CGFloat = 200.0
            static let cellOpen: CGFloat = 500.0
        }
        
    }
    
    //MARK:- ALL ANIMATION FUNCTIONS HERE
    func animateCellsIntoView(cell: UITableViewCell) {
        
        let layerTransform = CATransform3DMakeTranslation(10, 10, -5)
        cell.layer.transform = layerTransform
        cell.alpha = 0.2
        
        UIView.animate(withDuration: 0.65, delay: 0.2, options: .curveEaseIn, animations: {
            
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
            
        }) {    (true) in
            
            print("Animation completed..")
        }
    }
    
    func blurEffect() {
        //TODO:- Creates a blurring effect for the other cells when one cell is tapped open
    }


}


