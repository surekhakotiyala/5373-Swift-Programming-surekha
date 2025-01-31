//
//  AppDelegate.swift
//  MyLocations
//
//  Created by M.I. Hollemans on 25/09/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//
import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        if let modelURL = NSBundle.mainBundle().URLForResource("DataModel",
            withExtension: "momd") { if let model = NSManagedObjectModel(contentsOfURL: modelURL) {
                let coordinator = NSPersistentStoreCoordinator( managedObjectModel: model)
                let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask)
                let documentsDirectory = urls[0] as NSURL
                let storeURL = documentsDirectory.URLByAppendingPathComponent(
                    "DataStore.sqlite")
                var error: NSError?
                if let store = coordinator.addPersistentStoreWithType(
                    NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
                {
                    let context = NSManagedObjectContext()
                    context.persistentStoreCoordinator = coordinator
                    return context
                }
                    
                else
                {
                    println(
                        "Error adding persistent store at \(storeURL): \(error!)")
                }
            } else {
                println("Error initializing model from: \(modelURL)") }
        } else {
            println("Could not find data model in app bundle")
        }
        abort()
        }()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let tabBarController = window!.rootViewController
        as UITabBarController
        if let tabBarViewControllers = tabBarController.viewControllers { let currentLocationViewController =
        tabBarViewControllers[0] as CurrentLocationViewController
        currentLocationViewController.managedObjectContext = managedObjectContext
        }
        return true
    }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

