//
//  CoachMarkViewController.swift
//  usability
//
//  Created by Aman Gahlot on 9/29/16.
//  Copyright © 2016 goibibo. All rights reserved.
//

import UIKit

protocol CoachMarkViewControllerDelegate: class {
    func showPreviewInBrowserGuideView(show: Bool)
}

class CoachMarkViewController: UIViewController {

    @IBOutlet weak var coachImageView: UIImageView!
    @IBOutlet weak var twoFingerImageView: UIImageView!
    @IBOutlet weak var constrainTwoFingerViewCenter: NSLayoutConstraint!
    
    var delegate: CoachMarkViewControllerDelegate?
    
    //MARK:- View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         doFadeInAnimation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.showPreviewInBrowserGuideView(show: true)
    }
    
    //MARK:- Private Methods
    func doFadeInAnimation(){
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0.8
        }) { (result) in
            
            self.view.backgroundColor = UIColor.clear
            self.perform(#selector(self.slideAnimateTwoFingerImage), with: nil, afterDelay: 0.5)
        }
    }
    
    func slideAnimateTwoFingerImage() {
        UIView.animate(withDuration: 0.75) {
            self.constrainTwoFingerViewCenter.constant = -66
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- IBAction Methods
    @IBAction func actionCloseButtonTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: false)
    }
}
