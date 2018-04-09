//  Alerts.swift
//
//  Created by Julia Nikitina on 03.04.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.

import UIKit

struct Alert {

    //alert for the case if geolocation services are not allowed for the app
    static var alertToAppSettings: UIAlertController {
        let alert = UIAlertController(title: "Не можем определить город",
                                      message: "Если вы хотите, чтобы город был найден автоматически, разрешите приложению доступ к службам геолокации",
                                      preferredStyle: .actionSheet)
        //open app settings
        let okAction = UIAlertAction(title: "Открыть настройки",
                                     style: .cancel) { action in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) as URL? {
                UIApplication.shared.open(url)
            }
        }
        
        //ask me again later
        let cancelAction = UIAlertAction(title: "В другой раз", style: .default) { action in
            //we don't want to annoy users, so we should remember their preferences
            UserDefaults.standard.set(true, forKey: "isAlertAllowed")
            return
        }
        
        //don't ask again
        let cancelAlerts = UIAlertAction(title: "Больше не спрашивать", style: .default) { action in
            UserDefaults.standard.set(false, forKey: "isAlertAllowed")
            return
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addAction(cancelAlerts)
        
        return alert
    }
    
    //if geolocation services are disabled on the device
    static var alertToGeneralSettings: UIAlertController {
        let alert = UIAlertController(title: "Не можем определить город",
                                      message: "Если вы хотите, чтобы город был найден автоматически, включите службы геолокации в настройках",
                                      preferredStyle: .actionSheet)
        //open general settings - you need to add URL type "App-Prefs" in project settings
        let okAction = UIAlertAction(title: "Открыть настройки",
                                     style: .cancel) { action in
            if let url = NSURL(string: "App-Prefs:root") as URL? {
                UIApplication.shared.open(url)
            }
        }
        //ask me later
        let cancelAction = UIAlertAction(title: "В другой раз",
                                         style: .default) { action in
            UserDefaults.standard.set(true, forKey: "isAlertAllowed")
            return
        }
        //don't ask me again
        let cancelAlerts = UIAlertAction(title: "Больше не спрашивать", style: .default) { action in
            UserDefaults.standard.set(false, forKey: "isAlertAllowed")
            return
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addAction(cancelAlerts)
        
        return alert
    }
}
