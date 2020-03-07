//
//  IssueDataAccessProvider.swift
//  SearchRepo
//
//  Created by Shashank Mishra on 07/03/20.
//  Copyright © 2020 Gamechange Solutions. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class IssueDataAccessProvider {
    
    private var issuesFromDB = BehaviorRelay<[Issue]>(value: [])
    private var managedObjectContext : NSManagedObjectContext
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        issuesFromDB.removeAll()
        managedObjectContext = delegate.persistentContainer.viewContext
    }
    
    // MARK: - fetching issues from DB and update observable todos
    public func fetchData() -> [Issue] {
        let fetchRequest = Issue.issueFetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            return []
        }
        
    }
    
    // MARK: - return observable issue
    public func fetchObservableData() -> Observable<[Issue]> {
        issuesFromDB.append(contentsOf: fetchData())
        return issuesFromDB.asObservable()
    }
    
    // MARK: - add new issue
    public func addIssue(_ object: IssueModel) {
        let newIssue = NSEntityDescription.insertNewObject(forEntityName: "Issue", into: managedObjectContext) as! Issue
        
        newIssue.id = object.id
        newIssue.title = object.title
        newIssue.body = object.body
        newIssue.commentCount = object.commentCount
        
        do {
            try managedObjectContext.save()
            issuesFromDB.append(contentsOf: [newIssue])
        } catch {
            fatalError("error saving data")
        }
    
    }
    
    // MARK: - remove all issues
    public func clearIssues() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Issue")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try managedObjectContext.execute(request)
        } catch {
            fatalError("error delete data")
        }
    }
    
    public func removeIssue(withIndex index: Int) {
        managedObjectContext.delete(issuesFromDB.value[index])
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("error delete data")
        }
    }
    
}
