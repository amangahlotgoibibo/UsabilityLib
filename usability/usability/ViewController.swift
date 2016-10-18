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

    @IBOutlet weak var projectTableView: UITableView!
    var projectArray: [String] = []
    
    //MARK:- View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialConfigurations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProjectTableViewWithDataFromNotification), name: NSNotification.Name(rawValue: "ProjectDataReloaded"), object: nil)
        
    }
    
    //MARK:- Private Methods
    
    func doInitialConfigurations() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        reloadProjectTableViewWithDataFromNotification()
    }
    
    func reloadProjectTableViewWithDataFromNotification() {
        
        projectArray.removeAll()
        
        let links = UserDefaults.standard.value(forKey: "links") as! [NSDictionary]
        
        for iterator in links {
        
            print(iterator)
            let i = iterator
            self.projectArray.append(i.value(forKey: "k") as! String)
        }
        projectTableView.reloadData()
        
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
        
        FirebaseHandler.sharedInstance.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print(value)
            let links = value?["links"] as? NSArray
            let iteration = links?[indexPath.row] as? NSDictionary
            webViewVC.URL = iteration?.value(forKey: "v") as! String
            webViewVC.loadContentToWebView()
        })

        UXCam.start(withKey: "42b96e22c4dd82d")
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
}

