//
//  DataSource.swift
//  KogdaTeplo
//
//  Created by Julia Nikitina on 28/08/2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import Foundation

final class DataSource {
    
    static let shared = DataSource()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "RU_ru")
        return dateFormatter
    }()
    
    lazy var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "ru_RU")
        return cal
    }()
    
    lazy var todayDate: Date = {
        let today = Date()
        return today
    }()
    
    lazy var regionsInRussian: [String]? = {
        do {
            if let path = Bundle.main.path(forResource: "regions", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: .utf8)
                let tmpRegionsInRussian = data.components(separatedBy: "\n")
                return tmpRegionsInRussian
            }
        } catch let err as NSError { print(err) }
        return nil
    }()
    
    //"Москве", "Челябинске" и тд
    lazy var regionsInRussianForUse: [String]? = {
        do {
            if let path = Bundle.main.path(forResource: "regions_for_use", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: .utf8)
                let tmpRegionsInRussianForUse = data.components(separatedBy: "\n")
                return tmpRegionsInRussianForUse
            }
        } catch let err as NSError { print(err) }
        return nil
    }()
    
    lazy var regionsInEnglish: [String]? = {
        do {
            if let path = Bundle.main.path(forResource: "regions_en", ofType: "txt") {
                let data = try String(contentsOfFile:path, encoding: .utf8)
                let regionsInEnglish = data.components(separatedBy: "\n")
                return regionsInEnglish
            }
        } catch let err as NSError { print(err) }
        return nil
    }()
}
