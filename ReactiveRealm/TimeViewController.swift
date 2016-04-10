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
import Darwin

class TimeViewController: UIViewController {
    
    let timeDetailSegue = "TimeDetailSegue"
    
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
        
        
        // Combine both Time objects fetched from the Realm and the notification for new Time objects being written into the Realm
        let initialObjects = realm.rx_objects(Time)
        let notification = realm.objects(Time).rx_addNotification()
        
        // Combine and bind the observables onto the tableView
        Observable.of(initialObjects, notification).merge().bindTo(tableView.rx_itemsWithCellIdentifier("cell", cellType: UITableViewCell.self)) { (row, element, cell) in
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        let time = Time()
        realm.rx_add([time]).subscribe().dispose()
        
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

