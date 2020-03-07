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

class CommentViewModel {
        
    //Poplulate Data from API
    func data(_ id: Int32) -> Observable<[CommentModel]> {
      return CommentViewModel.getCommentsFromServerFor(id)
    }
    
    static func getCommentsFromServerFor(_ id: Int32) -> Observable<[CommentModel]> {
        guard let url = URL(string: "https://api.github.com/repos/firebase/firebase-ios-sdk/issues/\(id)/comments") else {
            return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .catchErrorJustReturn([])
            .map(parse)
    }
    
    static func parse(json: Any) -> [CommentModel] {
        guard let items = json as? [Any]  else {
            return []
        }
        var comments = [CommentModel]()
        items.forEach{
            do {
                let data = try JSONSerialization.data(withJSONObject: $0, options: JSONSerialization.WritingOptions.prettyPrinted)
                let result = try JSONDecoder().decode(CommentModel.self, from: data)
                comments.append(result)
            } catch let error {
                print(error)
            }
        }
        return comments
    }
    
}

// Comment model
struct CommentModel: Codable {
    let body: String
    let username: String

    private enum CodingKeys: String, CodingKey {
        case body
        case user = "user"
        case username = "login"
    }
    
    // Decoding
       init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           body = try container.decode(String.self, forKey: .body)
           let user = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
           username = try user.decode(String.self, forKey: .username)
       }
       // Encoding
       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(body, forKey: .body)
           var user = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
           try user.encode(username, forKey: .username)
       }
}
