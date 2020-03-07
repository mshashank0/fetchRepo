//
//  Issue+CoreDataClass.swift
//  SearchRepo
//
//  Created by Shashank Mishra on 07/03/20.
//  Copyright © 2020 Gamechange Solutions. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Issue)
public class Issue: NSManagedObject {

}

struct IssueModel: Codable {
    let id: Int32
    let title: String
    let body: String
    let commentCount: Int32

    private enum CodingKeys: String, CodingKey {
        case id = "number"
        case title
        case body
        case commentCount = "comments"
    }
    
}

extension String {
    
    var getTrimmedBody: String {
        get {
           let length = (self as NSString).length
           if length >= 140 {
               return (self as NSString).substring(with: NSRange(location: 0, length: 139))
           }
           return self
        }
    }
    
}
