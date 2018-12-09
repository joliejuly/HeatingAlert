//
//  AppDelegate.swift
//  SpacePhotoJSONLesson
//
//  Created by Yulia Taranova on 08.03.2018.
//  Copyright © 2018 Yulia Taranova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let mainStoryboard = UIStoryboard(name: "Main",
                                          bundle: nil)
        guard
            let nav = mainStoryboard.instantiateInitialViewController()
                as? UINavigationController
            else { return true }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        coordinator = Coordinator(router: nav)
        coordinator?.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        HeatingInfo.saveDataOnDisk()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        HeatingInfo.saveDataOnDisk()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        HeatingInfo.saveDataOnDisk()
    }
}
