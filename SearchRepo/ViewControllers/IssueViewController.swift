//
//  IssueViewController.swift
//  SearchRepo
//
//  Created by Shashank Mishra on 07/03/20.
//  Copyright © 2020 Gamechange Solutions Assignment. All rights reserved.
//

import RxSwift
import RxCocoa

class IssueViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = IssueViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Checking if 24 hours has been exceeded
        var isNewDay = false
        let date = UserDefaults.standard.object(forKey: "ApiHitTime") as? Date
        if date != nil, let diff = Calendar.current.dateComponents([.hour], from: date!, to: Date()).hour, diff > 24 {
            isNewDay = true
        }
        else if date == nil {
            isNewDay = true
        }
        
        if isNewDay {
            // Get issues from the git api
            viewModel.data
                .bind(to: tableView.rx.items(cellIdentifier: "IssueCell",
                cellType: UITableViewCell.self)) {  _, issue, cell in
                   cell.textLabel?.text = issue.title
                   cell.detailTextLabel?.text = issue.body.getTrimmedBody
            }
            .disposed(by: disposeBag)
        }
        else {
            // Get issues from the local storage
            viewModel.getIssues()
                .bind(to: tableView.rx.items(cellIdentifier: "IssueCell",
                                             cellType: UITableViewCell.self)) {  _, issue, cell in
                                                cell.textLabel?.text = issue.title
                                                cell.detailTextLabel?.text = issue.body.getTrimmedBody
            }
            .disposed(by: disposeBag)
            
        }
        
        //Selection of row(on model select) to show the comment
        tableView
            .rx
            .modelSelected(IssueModel.self)
            .subscribe(onNext :{ [weak self] model in
                
                guard let strongSelf = self else { return }
                if model.commentCount > 0 {
                    strongSelf.performSegue(withIdentifier: "CommentIdentifier", sender: ["id": model.id])
                }
                else {
                    let alert = UIAlertController(title: nil, message: "Comments not available", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentIdentifier", let object = sender as? [String: Int32], let id = object["id"] {
            let commentDetailsVC = segue.destination as? CommentViewController
            commentDetailsVC?.issueId = id
        }
    }
}


