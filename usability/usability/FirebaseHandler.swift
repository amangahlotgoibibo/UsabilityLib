//
//  FirebaseHandler.swift
//  usability
//
//  Created by Aman Gahlot on 10/17/16.
//  Copyright © 2016 goibibo. All rights reserved.
//

import UIKit
import Firebase

class FirebaseHandler: NSObject {
    
    var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
    static let sharedInstance: FirebaseHandler = FirebaseHandler()

    
    func reloadProjectTableData() {
        
        ref.observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let linkArray = value?["links"] as? NSArray
            
            UserDefaults.standard.setValue(linkArray, forKey: "links")

            let notif = Notification(name: NSNotification.Name(rawValue: "ProjectDataReloaded"))
            NotificationCenter.default.post(notif)

            
        })
    }
    
    
}
