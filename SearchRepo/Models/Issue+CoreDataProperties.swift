//
//  Issue+CoreDataProperties.swift
//  SearchRepo
//
//  Created by Shashank Mishra on 07/03/20.
//  Copyright © 2020 Gamechange Solutions. All rights reserved.
//
//

import Foundation
import CoreData


extension Issue {

    @nonobjc public class func issueFetchRequest() -> NSFetchRequest<Issue> {
        return NSFetchRequest<Issue>(entityName: "Issue")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var commentCount: Int32
    @NSManaged public var comment: NSSet?
    

}

