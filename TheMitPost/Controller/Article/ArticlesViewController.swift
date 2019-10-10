//
//  FirstViewController.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import NotificationCenter

import OnboardKit
import Hero
import NotificationBannerSwift
import MaterialComponents
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON
import Lottie
import SDWebImage


class ArticlesViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITabBarControllerDelegate, UNUserNotificationCenterDelegate {
    
    var notificationCenter = NotificationCenter.default
    
    fileprivate let heroTransition = HeroTransition()
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
        presentBottomMenu()
    }
    
    let API = "https://app.themitpost.com/posts";
    var articlesList = [Article]()
    
    @IBOutlet var articleCollectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    
    let window: UIWindow? = nil
    let _storyboard_ = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    @IBOutlet weak var logoutSigninBarButton: UIBarButtonItem!
    
    //MARK: Onboarding
    lazy var onboardingPages: [OnboardPage] = {
        
        let pageOne = OnboardPage(title: "Welcome aboard",
                                  imageName: "reading",
                                  description: "The Post app provides a rich reading experience with articles ranging from international matters to detailed college event converages", advanceButtonTitle: "Great!")
        
        let pageTwo = OnboardPage(title: "The notice is served",
                                  imageName: "school",
                                  description: "Important notices sent from the administration will be delivered to you at your comfort",
                                  advanceButtonTitle: "Awesome!")
        
        let pageThree = OnboardPage(title: "Socialize",
                                    imageName: "laugh",
                                    description: "Attending college events got a whole lot of easier with just a single swipe and a tap!", advanceButtonTitle: "Count me in")
        
        let pageFour = OnboardPage(title: "Be notified",
                                   imageName: "message",
                                   description: "To add icing on the cake, we provide rich push notifications so you stay on top of things as they happen",
                                   advanceButtonTitle: "Next",
                                   actionButtonTitle: "Enable notifications",
                                   action: { [weak self] completion in
                                    
                                    print("Enable notifications tapped")
                                       
                                       //check if push notifcations is turned, regardless ask for it once more
                                    
                                    if #available(iOS 10.0, *) {
                                      // For iOS 10 display notification (sent via APNS)
                                        UNUserNotificationCenter.current().delegate = self

                                      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                                        
                                      UNUserNotificationCenter.current().requestAuthorization (
                                        
                                        options: authOptions,
                                        completionHandler: {granted, error in
                                            
                                            if granted {
                                                print("Successfully granted notification permission")

                                            } else {
                                                print("Notification permission denied")
                                            }
                                      })
                                        
                                    } else {
                                        
                                      let settings: UIUserNotificationSettings =
                                      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                                        UIApplication.shared.registerUserNotificationSettings(settings)
                                    }

                                    UIApplication.shared.registerForRemoteNotifications()
                                    
                                    }
                                )
        
        let pageFive = OnboardPage(title: "Thank you",
        imageName: "success",
        description: "We hope you enjoy your experience with our app", advanceButtonTitle: "Done")
        
        return [pageOne, pageTwo, pageThree, pageFour, pageFive]
        
    }()
    
    var articlesShown = [Bool]()
    
    func onboard() {
        
        var backgroundColor: UIColor
        var labelColor: UIColor
        var titleColor: UIColor
        
        if #available(iOS 13, *) {
            
            labelColor = .secondaryLabel
           
            if traitCollection.userInterfaceStyle == .dark {
                backgroundColor = .background
                titleColor = .white
                
                 
            } else {
                backgroundColor = .white
                titleColor = .darkText
    
            }
            
        } else {
            labelColor = .darkGray
            backgroundColor = .white
            titleColor = .darkText
        }
        
        let boldTitleFont = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        let mediumTextFont = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        let appearanceConfiguration = OnboardViewController.AppearanceConfiguration(
                                                            tintColor: .systemBlue,
                                                            titleColor: titleColor,
                                                            textColor: labelColor,
                                                            backgroundColor: backgroundColor,
                                                            titleFont: boldTitleFont,
                                                            textFont: mediumTextFont)
        
        let onboardingVC = OnboardViewController(pageItems: onboardingPages, appearanceConfiguration: appearanceConfiguration ,completion: {
            
            print("onboarding complete")
            
            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
            
            if isRegisteredForRemoteNotifications {
                 let banner = NotificationBanner(title: "Great!", subtitle: "All set for the best app experience", style: .success)
                 banner.show()
                
            } else {
                 let banner = NotificationBanner(title: "Ugh!", subtitle: "Please enable push notifications for a better experience", style: .warning)
                 banner.show()
            }
            
        })
        
        onboardingVC.modalPresentationStyle = .formSheet
        onboardingVC.presentFrom(self, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition!
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    func setupNotificationCenter() {
        notificationCenter.addObserver(self, selector: #selector(refresh), name: Notification.Name("notice"), object: nil)
    }
    
    //MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboard()
        
        setupNotificationCenter()
        
        mode()
        startActivityIndicator()
        
        //MARK: Hero Setup
        
        self.hero.isEnabled = true
        self.navigationController?.delegate = self
        
        self.navigationController?.hero.navigationAnimationType = .selectBy(presenting: .zoomOut, dismissing: .zoomSlide(direction: .right))
        
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.addSubview(refreshControl)
        
        tabBarController?.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
      
        retrieveArticles { (success) in
            
            if !success {
                
                self.emptyView(action: "make")
                self.stopActivityIndicator()
                
            } else {
                self.stopActivityIndicator()
                
            }
            
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    //MARK: CREATE LOADING VIEW
    var activityIndicator: NVActivityIndicatorView!
    func startActivityIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 50, height: 50), type: .circleStrokeSpin, color: .lightGray, padding: 0)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    //MARK: CREATE EMPTY VIEW
    let emptyImageView = AnimationView()
    
    var emptyLabel = UILabel()
    var refreshButton = UIButton()
    
    func emptyView(action: String) {
        
        if action == "make" {
            let animation = Animation.named("post", subdirectory: "Lottie-Files")
            emptyImageView.animation = animation
            emptyImageView.loopMode = .loop
            
            emptyLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 120, width: 200, height: 30))
            emptyLabel.center.x = self.view.center.x
            emptyLabel.text = "Could not fetch articles.."
            self.view.addSubview(emptyLabel)
            
            emptyImageView.frame = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 100, width: 250, height: 250.0)
            emptyImageView.center.x = self.view.center.x
            
            self.view.addSubview(emptyImageView)
            emptyImageView.play()
            
            refreshButton = UIButton(frame: CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + 150, width: 150, height: 30))
            refreshButton.center.x = self.view.center.x
            refreshButton.layer.cornerRadius = 8
            refreshButton.backgroundColor = .systemGray
            refreshButton.setTitle("Tap to refresh", for: .normal)
            refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
            
            self.view.addSubview(refreshButton)
            
        }
        
        
        else if action == "remove" {
            
            print("removing empty views")
            emptyImageView.removeFromSuperview()
            refreshButton.removeFromSuperview()
            emptyLabel.removeFromSuperview()
            
        }
        
    }
    
    @objc func refresh() {
        
        emptyView(action: "remove")
        startActivityIndicator()
        
        retrieveArticles { (success) in
            
            if success {
                
                let banner = StatusBarNotificationBanner(title: "Great! Internet connection is back", style: .success)
                banner.show()
                banner.haptic = .light
                
                self.emptyView(action: "remove")
                
            } else {
                self.emptyView(action: "make")
                self.stopActivityIndicator()
            }
        }
        
    }
    
    //MARK:- FETCH ARTICLES
    var selectedArticle: Article?
    
    private func retrieveArticles(completion: @escaping (Bool) -> ()) {
        
        Alamofire.request(API, method: .get).responseJSON { response_ in
            
            guard let resultValue = response_.result.value else {
                //MARK: Data connection banner
                
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                
                let banner = StatusBarNotificationBanner(title: "Oops! Check your internet connection", style: .danger)
                banner.haptic = .heavy
                banner.show()
                
                completion(false)
                return
            }
            
            self.articlesList = [Article]()
            
            self.parseArticleResult(result: JSON(resultValue))
            
            self.stopActivityIndicator()
            
            self.articleCollectionView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.articlesShown = [Bool](repeating: false, count: self.articlesList.count)
            
            print("Retrieved articles!")
            
            if(self.articlesList.count == 0) {
                completion(false)
                
            } else {
                completion(true)
            }
            
        }
        
    }
    
    private func parseArticleResult(result: JSON) {
        
        print(result.count)
        
        for i in 0...result.count {
            
            let data = result[i]
            print(data)
            print("Message \(data["message"])")
            
            let year = data["date"]["year"].stringValue
            let month = data["date"]["month"].stringValue
            let day = data["date"]["day"].stringValue
            
            let category = data["category"].stringValue
            
            let date = day + " " + month + " " + year
            
            let article = Article(articleID: data["_id"].stringValue, title: String(htmlEncodedString: data["title"].stringValue)!,author: data["author"]["name"].stringValue, date: date, featured_media: data["featured_media"].stringValue, message_: data["message"].stringValue, category_: category, articleLink: data["link"].stringValue, content: nil)
            
            
            articlesList.append(article)
        
        }
        
        
    }
    
    @objc func refreshArticles() {
        
        retrieveArticles{ (sucess) in
            
            if(sucess) {
            
                self.articlesShown = [Bool](repeating: false, count: self.articlesList.count)
                print("Finished refreshing..")
                
            }
        }
        
    }
    
    
    //MARK:- Configue UI
    /*override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }*/
    
    func mode() {
        
        if #available(iOS 13.0, *) {
            
            if traitCollection.userInterfaceStyle == .dark {
                
                print("dark mode detected")
                self.navigationController?.navigationBar.barTintColor = .background
                self.tabBarController?.tabBar.barTintColor = .background

                self.view.backgroundColor = .background
                articleCollectionView.backgroundColor = .background
                
            } else {
                
                print("light mode detected")
                self.navigationController?.navigationBar.barTintColor = .systemOrange
                self.tabBarController?.tabBar.barTintColor = .white
                
                self.view.backgroundColor = .white
                articleCollectionView.backgroundColor = .white
                
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
       mode()
    }

    
    //MARK:- UICOLLECTIONVIEW DATASOURCE AND DELEGATE METHODS
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let articleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? ArticleCollectionViewCell {
            
            articleCell.article = articlesList[indexPath.row]
            
            return articleCell
            
        } else {
            fatalError("Missing cell for indexPath: \(indexPath)")
        }
    }
    
    
    //MARK:- UICOLLECTIONVIEWDELEGATEFLOWLAYOUT METHODS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.width - (ArticleCollectionViewCell.cellPadding * 2), height: ArticleCollectionViewCell.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: ArticleCollectionViewCell.cellPadding + 15, left: 30.0, bottom: 30.0, right: 30.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return ArticleCollectionViewCell.cellPadding + 10  // need to trial and test this number to suit all iOS devices (iPhone 5S and upwards). This worked good on iPhone X
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if articlesShown[indexPath.row] == false {
            
            let transform = CATransform3DTranslate(CATransform3DIdentity, -5, 50, -5)
            cell.layer.transform = transform
            cell.alpha = 0.0
            
            
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                // transform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 2)
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
                
            }) { (true) in
                print("Animation complete")
                
            }
            
            articlesShown[indexPath.row] = true
            
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.articleCollectionView.setContentOffset(CGPoint.zero, animated: true)
        }
        
    }
    
    //MARK: Navigation Controller Delegate
    
    
    //MARK: FOR HERO
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        return heroTransition.navigationController(navigationController, interactionControllerFor: animationController)
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return heroTransition.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
    
    //MARK:- SEGUES
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "articleViewSegue" {
           
            if let destinationViewController = segue.destination as? ArticleWebViewController {
                
                let selectedCell = sender as? ArticleCollectionViewCell
                let indexPath = self.articleCollectionView.indexPath(for: selectedCell!)
                
                let selectedArticle = articlesList[(indexPath?.row)!]
                
                destinationViewController.POST_ID = selectedArticle.articleID
                destinationViewController.category = selectedArticle.category
                destinationViewController.articleMessage = selectedArticle.message
                destinationViewController.articleURL = selectedArticle.articleLink
                destinationViewController.articleTitle = selectedArticle.title
                destinationViewController.articleAuthor = selectedArticle.author
                
            }
        }
    }
    
    @IBAction func unwindToArticlesListFromArticle(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? ArticlesViewController {
            print("Unwinding back to articles list")
        }
    }
    
    @IBAction func unwindToArticlesListFromSLCM(sender: UIStoryboardSegue) {
        
        if let _ = sender.source as? SLCMLoginViewController {
            print("Unwinding back to articles list")
        }
    }
    
    //MARK: Bottom Settings View
   
    func presentBottomMenu() {
        
        if #available(iOS 13, *) {
            
            guard let menuController = storyboard?.instantiateViewController(identifier: "menu") as? AboutViewController else {
                return
            }
            
            let sheet = MDCBottomSheetController(contentViewController: menuController)
            sheet.preferredContentSize = CGSize(width: self.view.frame.width, height: 365.0)
            present(sheet, animated: true, completion: nil)
            
        } else {
            
            guard let menuController = storyboard?.instantiateViewController(withIdentifier: "menu") as? AboutViewController else {
                return
            }
            
            let sheet = MDCBottomSheetController(contentViewController: menuController)
            sheet.preferredContentSize = CGSize(width: self.view.frame.width, height: 365.0)
            present(sheet, animated: true, completion: nil)
            
        }
        
        
    }

}

