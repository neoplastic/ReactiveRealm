//
//  ReactiveRealm.swift
//  ReactiveRealm
//
//  Created by David Wong on 8/04/2016.
//  Copyright © 2016 5dayapp. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - Realm Extension
public extension Realm {
    
    /**
     Add a sequence of model objects into the Realm.
     
     An NSError maybe produced if the transaction could not be written.
     - parameter objects: A sequence of realm objects
     - parameter update: if set to true, will find or create. This requires an indexed id.
     - Returns: an observable
     */
    func rx_add<S: SequenceType where S.Generator.Element: Object>(objects: S, update: Bool = false) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.write({
                    self.add(objects, update: update)
                })
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    
    /**
     Add model object into the Realm.
     
     An NSError maybe produced if the transaction could not be written.
     - parameter type: A realm model class type
     - parameter value: A dictionary that will be mapped to the model object.
     - parameter update: if set to true, will find or create. This requires an indexed id.
     - Returns: an observable
     */
    func rx_create<T: Object>(type: T.Type, value: AnyObject = [:], update: Bool = false)-> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.write({
                    self.create(type, value: value, update: update)
                })
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    
    /**
     Remove an object from the Realm
     
     An NSError maybe produced if the transaction could not be written.
     - parameter object: The object to remove
     - Returns: an observable
     */
    func rx_delete(object: Object) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.write({
                    self.delete(object)
                })
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    
    /**
     Remove an object from the Realm.
     
     An NSError maybe produced if the transaction could not be written.
     - parameter objects: The objects to remove
     - Returns: an observable
     */
    func rx_delete<S: SequenceType where S.Generator.Element: Object>(objects: S) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.write({
                    self.delete(objects)
                })
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    
    /**
     Remove an object from the Realm.
     
     An NSError maybe produced if the transaction could not be written.
     - parameter object: The objects to remove
     - Returns: an observable
     */
    func rx_delete<T: Object>(objects: List<T>) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.write({
                    self.delete(objects)
                })
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    
    /**
     Remove an object from the Realm.
     
     An NSError maybe produced if the transaction could not be written.
     - parameter object: The objects to remove
     - Returns: an observable
     */
    func rx_delete<T: Object>(objects: Results<T>) ->  Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.write({
                    self.delete(objects)
                })
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    
    /**
     Removes all objects from this Realm.
     
     An NSError maybe produced if the transaction could not be written.
     - Returns: an observable
     */
    func rx_deleteAll() -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try self.write({
                    self.deleteAll()
                })
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    
    /**
     Returns all objects of the given type in the Realm.
     
     An NSError maybe produced if the transaction could not be written.
     - parameter object: The objects to remove
     - Returns: an observable
     */
    func rx_objects<T: Object>(type: T.Type) -> Observable<RealmSwift.Results<T>> {
        return Observable.create { (observer) in
            observer.onNext(self.objects(type))
            observer.onCompleted()
            
            return NopDisposable.instance
        }
    }
    
    /**
     Get an object with the given primary key.
     
     Returns `nil` if no object exists with the given primary key.
     - parameter type: The type of the objects to be returned.
     - parameter key: The primary key of the desired object.
     - returns: An observable
     */
    func rx_objectForPrimaryKey<T: Object>(type: T.Type, key: AnyObject) -> Observable<T?> {
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(realm.objectForPrimaryKey(type, key: key))
            observer.onCompleted()
            
            return NopDisposable.instance
        })
    }
    /**
     Add a notification for changes in this Realm.
     
     - parameter object: The objects to remove
     - Returns: an observable
     */
    func rx_addNotification() -> Observable<(Notification, Realm)> {
        return Observable.create({ (observer) -> Disposable in
            let token = self.addNotificationBlock({ (notification: Notification, realm: Realm) in
                observer.onNext((notification, realm))
            })
            return AnonymousDisposable {
                token.stop()
            }
        })
    }
}

// MARK: - AnyRealmCollection Extension

public extension AnyRealmCollection {
    /**
     Register a block to be called each time the collection changes
     
     - Returns: an observable
     */
    func rx_addNotification() -> Observable<AnyRealmCollection<T>> {
        return Observable.create({ (observer) -> Disposable in
            let token = self.addNotificationBlock({ (collection: AnyRealmCollection<T>?, error: NSError?) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let collection = collection {
                    observer.onNext(collection)
                }
            })
            return AnonymousDisposable {
                token.stop()
            }
        })
    }
}

// MARK: - Results Extension

public extension Results {
    /**
     Register a block to be called each time the Results changes.
     
     - Returns: an observable
     */
    func rx_addNotification() -> Observable<(Results<T>)> {
        return Observable.create({ (observer) -> Disposable in
            let token = self.addNotificationBlock({ (results: Results<T>?, error: NSError?) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let results = results {
                    observer.onNext(results)
                }
            })
            return AnonymousDisposable {
                token.stop()
            }
        })
    }
    
    
}

// MARK: - List Extension

public extension List {
    /**
     Register a block to be called each time the List changes.
     
     - Returns: an observable
     */
    func rx_addNotification() -> Observable<(List<T>)> {
        return Observable.create({ (observer) -> Disposable in
            let token = self.addNotificationBlock({ (list: List<T>) in
                observer.onNext(list)
            })
            return AnonymousDisposable {
                token.stop()
            }
        })
    }
}