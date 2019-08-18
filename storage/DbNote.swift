//
//  DbNote.swift
//  Notes
//
//  Created by user on 17.08.2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import CoreData

@objc(DbNote)
public class DbNote: NSManagedObject {
    
}

extension DbNote {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DbNote> {
        return NSFetchRequest<DbNote>(entityName: "DbNote")
    }
    
    @NSManaged public var colorA: Float
    @NSManaged public var colorBlue: Float
    @NSManaged public var colorGreen: Float
    @NSManaged public var colorRed: Float
    @NSManaged public var content: String?
    @NSManaged public var importance: String?
    @NSManaged public var title: String?
    @NSManaged public var uid: String?
    @NSManaged public var selfDestructionDate: NSDate?
    
}
