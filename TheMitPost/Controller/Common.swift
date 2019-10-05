//
//  Common.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 05/10/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import Lottie

protocol PostViewDelete {
    func emptyView(action: String)
}

//class Common {
//
//    var view_: UIView?
//
//    init(view: UIView?) {
//        self.view_ = view
//    }
//
//    //MARK: CREATE EMPTY VIEW
//    let emptyImageView = AnimationView(name: "empty-box")
//    var refreshButton = UIButton()
//
//    func emptyView(action: String) {
//
//        guard let view = view_ else {
//            print("No super view found")
//            return
//        }
//
//        if action == "make" {
//
//            emptyImageView.frame = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 100, width: 250, height: 250)
//            emptyImageView.center.x = self.view.center.x
//
//            self.view.addSubview(emptyImageView)
//            emptyImageView.play()
//
//            refreshButton = UIButton(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + 150, width: 150, height: 30))
//            refreshButton.center.x = self.view.center.x
//            refreshButton.layer.cornerRadius = 8
//            refreshButton.backgroundColor = .systemGray
//            refreshButton.setTitle("Tap to refresh", for: .normal)
//            refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
//
//            self.view.addSubview(refreshButton)
//
//        }
//
//
//        else if action == "remove" {
//
//            print("removing empty views")
//            emptyImageView.removeFromSuperview()
//            refreshButton.removeFromSuperview()
//
//        }
//
//    }
//
//    @objc func refresh() {
//
//        emptyView(action: "remove")
//        startActivityIndicator()
//
//        retrieveArticles { (success) in
//
//            if success {
//                self.emptyView(action: "remove")
//
//            } else {
//                self.emptyView(action: "make")
//            }
//        }
//
//    }
//
//}


