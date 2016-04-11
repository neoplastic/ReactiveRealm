//
//  TimeDetailViewController.swift
//  ReactiveRealm
//
//  Created by David Wong on 10/04/2016.
//  Copyright © 2016 5dayapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import ReactiveRealm

class TimeDetailViewController: UIViewController {

    let disposeBag = DisposeBag()
    var time: Time!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var updateTimeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm.rx_addNotification()
            .subscribeNext { (notification, _) in
                self.updateLabels()
            print("notification: \(notification.rawValue)")
        }
            .addDisposableTo(disposeBag)
        
        realm.objects(Time)
            .filter(NSPredicate(format: "id == %@", time.id))
            .rx_addNotification()
            .map({ (results) -> Time in
                return results.first!
            })
            .subscribeNext { (results) in
            print("results: \(results)")
        }.addDisposableTo(disposeBag)
        
        updateTimeButton.rx_tap.flatMap { () -> Observable<Void> in
            return realm.rx_write({ 
                self.time.time = NSDate()
                realm.add(self.time, update: true)
            })
        }
            .subscribe()
            .addDisposableTo(disposeBag)
        
        updateLabels()
        
    }
    
    func updateLabels() {
        timeLabel.text = time.time.description
        idLabel.text = time.id
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
