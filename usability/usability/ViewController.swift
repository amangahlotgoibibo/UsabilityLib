//
//  ViewController.swift
//  usability
//
//  Created by Aman Gahlot on 9/28/16.
//  Copyright © 2016 goibibo. All rights reserved.
//

import UIKit
import UXCam

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var projectArray: [String] = ["abc","def","ghi","jkl","mno"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:- Table View Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell")! as UITableViewCell
        cell.textLabel?.text = projectArray[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let webViewVC = storyBoard.instantiateViewController(withIdentifier: "ProjectWebViewViewController") as! ProjectWebViewViewController
        UXCam.start(withKey: "42b96e22c4dd82d")
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
}
