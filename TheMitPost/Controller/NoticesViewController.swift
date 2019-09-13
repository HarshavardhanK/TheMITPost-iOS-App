//
//  NoticesViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 13/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoticesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let API = "https://api.themitpost.com/notices"
    
    @IBOutlet weak var noticesTableView: UITableView!
    
    var notices = [Notice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        noticesTableView.delegate = self
        noticesTableView.dataSource = self
        noticesTableView.separatorColor = .lightGray
        noticesTableView.rowHeight = UITableView.automaticDimension
        noticesTableView.estimatedRowHeight = 300
        
        retrieveNotices()
    }
    
    func retrieveNotices() {
        
        Alamofire.request(API, method: .get).responseJSON {
            response_ in
            
            let response = JSON(response_.result.value!)
            
            if response["status"] != "OK" {
                print("error")
                
            } else {
                
                let data = response["data"].arrayValue
                
                self.notices = parseNotices(data: data)
                
                self.noticesTableView.reloadData()
                
                print("Successfully loaded data")
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notice = notices[indexPath.row]
        
        if(notice.hasURL) {
            
            print("has url")
            
            if(notice.isImage) {
                
                print("image notice")
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageNoticeCell", for: indexPath) as! NoticeImageTableViewCell
                cell.url = notice.getComponentURL
                cell.titleText = notice.title
                cell.contentText = notice.content
                
                cell.selectionStyle = .none
                
                return cell
                
            } else {
                
                //TODO PDF CELL
                let cell = tableView.dequeueReusableCell(withIdentifier: "pdfNoticeCell", for: indexPath) as! NoticePDFTableViewCell
                
                return cell
              
            }
            
        } else {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textNoticeCell", for: indexPath) as! NoticeTextTableViewCell
            cell.titleText = notice.title
            cell.contentText = notice.content
            
            cell.selectionStyle = .none
            
            return cell
            
        }
    }
    
}
