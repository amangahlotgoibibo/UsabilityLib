//
//  ProjectWebViewViewController.swift
//  usability
//
//  Created by Aman Gahlot on 9/28/16.
//  Copyright © 2016 goibibo. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProjectWebViewViewController: UIViewController, UIWebViewDelegate, CoachMarkViewControllerDelegate {
   
    @IBOutlet weak var projectWebView: UIWebView!
    @IBOutlet weak var previewInBrowserGuideView: UIView!

    var nextButton = UIBarButtonItem()
    var hasAlreadyLoaded: Bool?
    var shouldShowPreviewInBrowserGuideView: Bool = false
    
    
    //MARK:- View Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadContentToWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.prefersStatusBarHidden = true
        if self.shouldShowPreviewInBrowserGuideView {
        showPreviewInBrowserGuideView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfigurations()
    }
    
    //MARK:- Private Methods
    
    func doInitialConfigurations() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ProjectWebViewViewController.actionNextButtonTapped)), animated: true)
        projectWebView.delegate = self
        hasAlreadyLoaded = false
        
        addSwipeGestureRecogniser()
        perform(#selector(showCoachmark), with: nil, afterDelay: 0.2)
        previewInBrowserGuideView.isHidden = true
    }
    
    func loadContentToWebView() {
       
        if hasAlreadyLoaded == false {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
//            let URL = "https://projects.invisionapp.com/share/3689FL89R#/screens"
            let URL = "https://projects.invisionapp.com/share/T27R7ZMWX#/screens/176323591"
            let requestURL = NSURL(string: URL)
            let request = NSURLRequest(url: requestURL! as URL)
            projectWebView.loadRequest(request as URLRequest)
            hasAlreadyLoaded = true

        }
    }
    
    func showPreviewInBrowserGuideView() {
        
        if shouldShowPreviewInBrowserGuideView == true {
            self.previewInBrowserGuideView.alpha = 0.8
            previewInBrowserGuideView.isHidden = false
            shouldShowPreviewInBrowserGuideView = false
//            perform(#selector(ProjectWebViewViewController.showPreviewInBrowserGuideView as (ProjectWebViewViewController) -> () -> ()), with: nil, afterDelay: 6.0)

        }
        else {
            
            UIView.animate(withDuration: 1.0, animations: {
                self.previewInBrowserGuideView.alpha = 0
                }, completion: { (result) in
                if result {
                    self.previewInBrowserGuideView.isHidden = true
                }
            })
           
            
        }
    }
    
    func actionNextButtonTapped() {
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let recInfoVC = sb.instantiateViewController(withIdentifier: "RecordingInfoViewController") as! RecordingInfoViewController
        self.navigationController?.pushViewController(recInfoVC, animated: true)
    }
    
    func addSwipeGestureRecogniser() {
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(ProjectWebViewViewController.handleRightSwipe))
        swipeRight.numberOfTouchesRequired = 2
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func handleRightSwipe() {
        actionNextButtonTapped()
    }
    
    func showCoachmark() {
       
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let reviewVC = sb.instantiateViewController(withIdentifier: "CoachMarkViewController") as! CoachMarkViewController
        if #available(iOS 8.0, *) {
            
            reviewVC.modalPresentationStyle = .overFullScreen
        }
        
        self.modalPresentationStyle = .currentContext
        reviewVC.delegate = self
        self.navigationController?.pushViewController(reviewVC, animated: false)
//        self.present(reviewVC, animated: false, completion: nil)
    }
    
    //MARK:- WebView Delegate Methos

    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
         perform(#selector(ProjectWebViewViewController.showPreviewInBrowserGuideView as (ProjectWebViewViewController) -> () -> ()), with: nil, afterDelay: 2.0)
    }
    
    //MARK:- CoachMarkViewControllerDelegate
    func showPreviewInBrowserGuideView(show: Bool) {
        self.shouldShowPreviewInBrowserGuideView = true
    }
    
    
}
