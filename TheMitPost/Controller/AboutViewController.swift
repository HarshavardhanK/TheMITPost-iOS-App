//
//  AboutViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 03/10/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var topThingView: UIView!
    @IBOutlet var clubNameLabel: UILabel!
    @IBOutlet var clubImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()
        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 20
        self.topThingView.layer.cornerRadius = self.topThingView.frame.width / 2 - 10
        
        //MARK: Round Image
        self.clubImageView.backgroundColor = .white
        self.clubImageView.layer.borderColor = UIColor.white.cgColor
        self.clubImageView.layer.borderWidth = 2
        self.clubImageView.layer.cornerRadius = clubImageView.frame.width / 2
        clubImageView.clipsToBounds = true
        
    }
    
    //MARK: UI THEME
    func mode() {
        
        if #available(iOS 13, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                view.backgroundColor = .background
                
            } else {
                
                view.backgroundColor = .white
                
            }
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
