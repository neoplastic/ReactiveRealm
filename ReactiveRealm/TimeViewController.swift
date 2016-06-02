//
//  MasterViewController.swift
//  ReactTrial
//
//  Created by David Wong on 8/04/2016.
//  Copyright © 2016 5dayapp. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import ReactiveRealm
import Darwin

class TimeViewController: UIViewController {
    
    let timeDetailSegue = "TimeDetailSegue"
    let viewModel = TimeListViewModel()
    
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the tap for bar button items.
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: nil)
        addButton.rx_tap.subscribeNext { () in
            let time = Time()
            realm.rx_add([time]).subscribe().dispose()
        }.addDisposableTo(disposeBag)
        
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        viewModel.timeObjectsObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier("cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = "\(element.time) @ row \(row)"
            }
            .addDisposableTo(disposeBag)

        tableView
            .rx_modelSelected(Time)
            .subscribeNext { (time) in
                self.performSegueWithIdentifier(self.timeDetailSegue, sender: time)
        }
            .addDisposableTo(disposeBag)
    }

    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == timeDetailSegue {
            guard let controller = segue.destinationViewController as? TimeDetailViewController,
                let time = sender as? Time
                else { return }
            controller.time = time
        }
    }
    
}

