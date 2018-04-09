//
//  AppDelegate.swift
//  HeatingAlert
//
//  Created by Julia Nikitina on 08.03.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //static var is used to guarantee that an instance of MainViewController will be created only once
    static var mainViewController: MainViewController? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let tmpMainViewController = appDelegate.window?.rootViewController as? MainViewController else { return nil }
        return tmpMainViewController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.mainViewController?.fetchHeatingData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Heating.saveDataOnDisk()
    }

    //we need to call fetch method here to guarantee that after changing settings and going back to the app user will see changed data
    func applicationWillEnterForeground(_ application: UIApplication) {
        AppDelegate.mainViewController?.fetchHeatingData()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let root = AppDelegate.mainViewController
            else { fatalError("Unexpected Main View Controller") }
        
        //reverse geocoding method works with the russian locale only in iOS 11 and newer
        if #available(iOS 11.0, *) {
            root.tryToRequestLocation()
            root.lookUpCurrentLocation(completionHandler: root.updateUIWithPlacemark)
        }
         root.fetchHeatingData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Heating.saveDataOnDisk()
    }
}
