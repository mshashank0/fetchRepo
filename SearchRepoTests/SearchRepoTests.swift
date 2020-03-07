//
//  SearchRepoTests.swift
//  SearchRepoTests
//
//  Created by Shashank Mishra on 07/03/20.
//  Copyright © 2020 Gamechange Solutions Assignment. All rights reserved.
//

import XCTest
@testable import SearchRepo

class SearchRepoTests: XCTestCase {
    var viewModel: IssueViewModel?
    
    override func setUp() {
        viewModel = IssueViewModel()
    }

    override func tearDown() {
        viewModel = nil
    }

    func testAddIssue() {
        
        var oldCount = 0
        viewModel?.getIssues().subscribe(onNext: { (issue) in
            oldCount = issue.count
            }, onError: nil, onCompleted: nil, onDisposed: nil).dispose()
        
        // add one issue
        viewModel?.addIssue(IssueModel(id: 123, title: "test", body: "test body", commentCount: 3))
        
        var newCount = 0
        viewModel?.getIssues().subscribe(onNext: { (issue) in
            newCount = issue.count
            }, onError: nil, onCompleted: nil, onDisposed: nil).dispose()
        XCTAssert(oldCount + 1 == newCount)
        
    }
    
    func testToParseIssuesJson() {
        let issueArray: [IssueModel] = viewModel?.parse(json: [demoIssueJSON]) ?? []
        let issue = issueArray.first
        XCTAssert(issue?.title == "Add Swift module support to ZipBuilder")
        XCTAssert(issue?.commentCount == 0)
    }
    
    func testToParseCommentJson() {
        let commentArray: [CommentModel] = CommentViewModel.parse(json: demoCommentJSON)
        XCTAssert(commentArray.count == 2)
        let comment = commentArray.first
        XCTAssert(comment?.body == "I found a few problems with this issue:\n  * I couldn't figure out how to label this issue, so I've labeled it for a human to triage. Hang tight.\n  * This issue does not seem to follow the issue template. Make sure you provide all the required information.")
        XCTAssert(comment?.username == "google-oss-bot")
    }

}


let demoIssueJSON =
["number": 5040,
  "title": "Add Swift module support to ZipBuilder",
  "comments": 0,
  "updated_at": "2020-03-07T02:18:35Z",
  "body": "#no-changelog"
    ] as [String : Any]

let demoCommentJSON =
[
    [
      "user": [
        "login": "google-oss-bot",
      ],
      "updated_at": "2019-06-20T23:12:55Z",
      "body": "I found a few problems with this issue:\n  * I couldn't figure out how to label this issue, so I've labeled it for a human to triage. Hang tight.\n  * This issue does not seem to follow the issue template. Make sure you provide all the required information."
    ],
    [
      "user": [
        "login": "christibbs",
        "site_admin": false
      ],
      "updated_at": "2019-07-15T17:08:41Z",
      "body": "@xiao99xiao could you share your code snippet for the handler method that gets called when you tap your button? I tried reproducing this with a sample app but I'm seeing normal behavior.\r\n\r\nMy method looks like:\r\n```\r\nlet buttonAction = InAppMessagingAction(actionText:self.iam.primaryActionButton.buttonText, actionURL: self.iam.primaryActionURL)\r\nself.delegate.messageClicked!(self.iam, with: buttonAction)\r\n```\r\n\r\nWhere `iam` is an instance of `InAppMessagingCardDisplay`."
    ]
] as [[String : Any]]
