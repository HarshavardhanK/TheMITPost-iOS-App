//
//  ArticleViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 01/02/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import SDWebImage
import MaterialComponents

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var article: Article?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var authorLabelView: UILabel!
    @IBOutlet weak var dateLabelView: UILabel!
    
    @IBOutlet weak var dateHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var stack: UIStackView!
    
    @IBOutlet weak var articleTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleHorizontalConstraint.constant -= view.bounds.width
        authorHorizontalConstraint.constant -= view.bounds.width
        dateHorizontalConstraint.constant -= view.bounds.width
    }
    
    let content = [Article.Content]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        articleTableView.rowHeight = UITableView.automaticDimension
        articleTableView.estimatedRowHeight = 300
        
        articleTableView.dataSource = self
        articleTableView.delegate = self
        
        animateIntoView(duration: 0.5, delay: 0.0, margin: view.bounds.width)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Optima", size: 20)!,
            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle]
        
        
        
        titleLabelView.lineBreakMode = .byWordWrapping
        titleLabelView.numberOfLines = 0
        
        titleLabelView.font = UIFont(name: "Optima", size: 22)
        authorLabelView.font = UIFont(name: "Optima", size: 16)
        
        dateLabelView.font = UIFont(name: "Avenir", size: 13)
        
        if let receivedArticle = article {
            
            let titleAttributedString = NSAttributedString(string: receivedArticle.title!, attributes: titleAttributes)

            titleLabelView.attributedText = titleAttributedString
            imageView.sd_setImage(with: URL(string: receivedArticle.featured_media!), completed: nil)
            dateLabelView.text = receivedArticle.date
            authorLabelView.text = receivedArticle.author
            
            print("Article content yet to receive..")

        } else {
            print("Article was not received..")
        }

        // Do any additional setup after loading the view.
    }
    
    func animateIntoView(duration: Double, delay: Double, margin: CGFloat) {
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseOut], animations: {
            
            self.authorHorizontalConstraint.constant += margin
            self.titleHorizontalConstraint.constant += margin
            self.dateHorizontalConstraint.constant += margin
            
            self.stack.layoutSubviews()
            
        }) { (true) in
            print("Animation successfull")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
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
