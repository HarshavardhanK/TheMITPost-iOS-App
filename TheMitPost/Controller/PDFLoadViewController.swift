//
//  PDFLoadViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 26/09/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import WebKit

class PDFLoadViewController: UIViewController {
    
    var url: URL?

    @IBOutlet weak var pdfWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PDF view controller")

        // Do any additional setup after loading the view.
        
        if let url_ = url {
            pdfWebView.load(URLRequest(url: url_))
        }
    }
}

