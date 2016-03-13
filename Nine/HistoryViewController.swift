//
//  HistoryViewController.swift
//  Nine
//
//  Created by Tian He on 3/13/16.
//  Copyright © 2016 Tian He. All rights reserved.
//

import Foundation

import UIKit
import CoreData
import Charts

class HistoryViewController : UIViewController {
    var moods = [FWMood]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let moodsFetch = NSFetchRequest(entityName: "Mood")
        
        
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        moodsFetch.sortDescriptors = [sortDescriptor];
        
        do {
            self.moods = try managedContext.executeFetchRequest(moodsFetch) as! [FWMood]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
