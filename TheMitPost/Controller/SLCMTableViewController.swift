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
    
    lazy var cellHeights = (0..<subjects.count).map{_ in Cell.CellHeight.cellClose}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        setup()
        
    }
    
    //MARK:- HELPERS
    func setup() {
        
        cellHeights = Array(repeating: Cell.CellHeight.cellClose, count: subjects.count)
        tableView.estimatedRowHeight = Cell.CellHeight.cellClose
        tableView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @objc func refreshHandler() {
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }

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
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
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
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectCellTableViewCell
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations

        // Configure the cell...

        return cell
    }
    
    fileprivate struct Cell {
        
        struct CellHeight {
            static let cellClose: CGFloat = 200.0
            static let cellOpen: CGFloat = 400.0
        }
        
    }


}


