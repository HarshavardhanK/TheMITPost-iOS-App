//
//  ImagePresentViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 22/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SDWebImage

class ImagePresentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image_url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.sd_setImage(with: image_url!, completed: nil)

        // Do any additional setup after loading the view.
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
