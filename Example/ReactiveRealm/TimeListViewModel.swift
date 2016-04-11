//
//  TimeListViewModel.swift
//  ReactiveRealm
//
//  Created by David Wong on 11/04/2016.
//  Copyright © 2016 5dayapp. All rights reserved.
//


import RxSwift
import RealmSwift
import RxCocoa
import ReactiveRealm

public class TimeListViewModel {
    
    /**
     Merges both Realm stored Time objects with a stream of newly added Realm objects
     - returns: An observerable of results
    */
    public func timeObjectsObservable() -> Observable<Results<Time>> {
        let initialObjects = realm.rx_objects(Time)
        let notification = realm.objects(Time).rx_addNotification()
        
        return Observable.of(initialObjects, notification).merge()
    }
}