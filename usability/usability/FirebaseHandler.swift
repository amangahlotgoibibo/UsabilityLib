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
    var projectElementArray: [String] = []
    
    static let sharedInstance: FirebaseHandler = FirebaseHandler()
    
    override init() {
//        ref = FIRDatabase.database().reference()
        
    }
    
//    func reloadProjectTableData() {
//        FirebaseHandler.sharedInstance.ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            print(value)
//            let links = value?["links"] as? NSArray
//            
//            for iterator in links! {
//                print(iterator)
//                let i = iterator as? NSDictionary
//                self.projectElementArray.append(i?.value(forKey: "k") as! String)
//            }
//        })
//        
//    }
    
    
}
