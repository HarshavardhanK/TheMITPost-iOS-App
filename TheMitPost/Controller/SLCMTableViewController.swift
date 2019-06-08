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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(UINib(nibName: "SubjectCellTableViewCell", bundle: nil), forCellReuseIdentifier: "subjectCell")
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
        
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
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
        
        UIView.animate(withDuration: duration, delay: 0.4, options: .curveEaseInOut, animations: {() -> Void in
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
            
            if cellHeights[indexPath.row] != Cell.CellHeight.cellClose {
                cell.unfold(false, animated: false, completion: nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
            
            //
            
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectCellTableViewCell

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate struct Cell {
        
        struct CellHeight {
            static let cellClose: CGFloat = 160.0
            static let cellOpen: CGFloat = 200.0
        }
    }


}


