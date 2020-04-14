//
//  Users+CoreDataProperties.swift
//  Database
//
//  Created by Admin on 03/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var password: String?
    @NSManaged public var userName: String?

}
