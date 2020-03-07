//
//  CommentViewController.swift
//  SearchRepo
//
//  Created by Shashank Mishra on 07/03/20.
//  Copyright © 2020 Gamechange Solutions Assignment. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTableView: UITableView!
    var issueId: Int32!
    
    var viewModel = CommentViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.data(issueId)
            .bind(to: commentTableView.rx.items(cellIdentifier: "CommentCell",
                                                cellType: UITableViewCell.self)) {  _, comment, cell in
                                                    cell.textLabel?.text = comment.username
                                                    cell.detailTextLabel?.text = comment.body
        }
        .disposed(by: disposeBag)
        
        viewModel.data(issueId)
            .map { "\($0.count) comments found" }
            .subscribe(onNext: { (text) in
                DispatchQueue.main.async {
                    self.navigationItem.title = text
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
    }
    
}

