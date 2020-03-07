//
//  IssueViewModel.swift
//  SearchRepo
//
//  Created by Shashank Mishra on 07/03/20.
//  Copyright © 2020 Gamechange Solutions. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class IssueViewModel {
    
    let issueDataAccessProvider = IssueDataAccessProvider()
    static var disposeBag = DisposeBag()
    
    lazy var data: Observable<[IssueModel]> = {
        return self.getIssuesFromRemote()
    }()
   
    public func getIssues() -> Observable<[IssueModel]> {
        let array = issueDataAccessProvider.fetchData()
        var issues = [IssueModel]()
        array.forEach{
            let object = IssueModel(id: $0.id, title: $0.title ?? "", body: $0.body ?? "", commentCount: $0.commentCount)
            issues.append(object)
        }
        return Observable.from(optional: issues)
    }
    
    // MARK: - new issue add
    public func addIssue(_ object: IssueModel) {
        issueDataAccessProvider.addIssue(object)
    }
    
}

// MARK: - Get issues from the API
extension IssueViewModel {
    
    public func getIssuesFromRemote() -> Observable<[IssueModel]> {
        
        self.issueDataAccessProvider.clearIssues()
        UserDefaults.standard.set(Date(), forKey:"ApiHitTime")
        
        guard let url = URL(string: "https://api.github.com/repos/firebase/firebase-ios-sdk/issues?sort=updated") else {
            return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .catchErrorJustReturn([])
            .map(parse)
    }
    
    public func parse(json: Any) -> [IssueModel] {
        guard let items = json as? [Any]  else {
            return []
        }
        var issues = [IssueModel]()
        items.forEach{
            do {
                let data = try JSONSerialization.data(withJSONObject: $0, options: JSONSerialization.WritingOptions.prettyPrinted)
                let result = try JSONDecoder().decode(IssueModel.self, from: data)
                issues.append(result)
                addIssue(result)
            } catch let error {
                print(error)
            }
        }
        return issues
    }
    
}

extension BehaviorRelay where Element: RangeReplaceableCollection {

       func append(_ subElement: Element.Element) {
           var newValue = value
           newValue.append(subElement)
           accept(newValue)
       }

       func append(contentsOf: [Element.Element]) {
           var newValue = value
           newValue.append(contentsOf: contentsOf)
           accept(newValue)
       }

       public func remove(at index: Element.Index) {
           var newValue = value
           newValue.remove(at: index)
           accept(newValue)
       }

       public func removeAll() {
           var newValue = value
           newValue.removeAll()
           accept(newValue)
       }

   }
