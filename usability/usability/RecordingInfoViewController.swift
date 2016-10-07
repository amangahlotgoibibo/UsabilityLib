//
//  RecordingInfoViewController.swift
//  usability
//
//  Created by Aman Gahlot on 10/7/16.
//  Copyright © 2016 goibibo. All rights reserved.
//

import UIKit
import UXCam

class RecordingInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionStartRecordingTapped(_ sender: AnyObject) {
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let reviewVC = sb.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }

    @IBAction func actionNotInterestedTapped(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
        UXCam.stopApplicationAndUploadData()
    }
}
