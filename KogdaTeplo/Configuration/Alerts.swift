//
//  Alerts.swift
//  КолесикоЗагрузки
//
//  Created by Yulia Taranova on 03.04.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

struct Alert {
    
    static var alertToAppSettings: UIAlertController {
        
        let alert = UIAlertController(title: "Не можем определить город", message: "Если вы хотите, чтобы город был найден автоматически, разрешите приложению доступ к службам геолокации", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Открыть настройки", style: .cancel) { action in
            //let's open settings for our app
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) as URL? {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "В другой раз", style: .default) { action in
            UserDefaults.standard.set(true, forKey: "isAlertAllowed")
            return
        }
        
        let cancelAlerts = UIAlertAction(title: "Больше не спрашивать", style: .default) { action in
            UserDefaults.standard.set(false, forKey: "isAlertAllowed")
            return
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addAction(cancelAlerts)
        
        return alert
        
    }
    
    static var alertToGeneralSettings: UIAlertController {
        let alert = UIAlertController(title: "Не можем определить город", message: "Если вы хотите, чтобы город был найден автоматически, включите службы геолокации в настройках", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Открыть настройки", style: .cancel) { action in
            //let's open settings for our app
            if let url = NSURL(string: "App-Prefs:root") as URL? {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "В другой раз", style: .default) { action in
            UserDefaults.standard.set(true, forKey: "isAlertAllowed")
            return
        }
        
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
