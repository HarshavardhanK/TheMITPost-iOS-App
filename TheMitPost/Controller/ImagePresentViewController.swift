//
//  ImagePresentViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 22/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SDWebImage

class ImagePresentViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image_url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("image presentation loaded")
        self.view.addSubview(imageScrollView)
        imageScrollView.delegate = self
        imageScrollView.addSubview(imageView)
        
        if let url = image_url {
            imageView.sd_setImage(with: url, completed: nil)
            
        } else {
            print("No URL found")
        }
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = .background
        self.view.backgroundColor = .black
        self.tabBarController?.tabBar.barTintColor = .background
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
