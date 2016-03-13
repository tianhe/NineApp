//
//  FWMood+CoreDataProperties.swift
//  Nine
//
//  Created by Tian He on 3/12/16.
//  Copyright © 2016 Tian He. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FWMood {

    @NSManaged var created_at: NSDate?
    @NSManaged var energy: NSNumber?
    @NSManaged var mood: NSNumber?

}
