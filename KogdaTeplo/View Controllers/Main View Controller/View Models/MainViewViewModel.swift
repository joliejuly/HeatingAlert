//
//  MainViewViewModel.swift
//  KogdaTeplo
//
//  Created by Julia Nikitina on 07.04.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import Foundation

struct MainViewViewModel {
    
    var heatingInfos: [Heating]
    
    func textForCityLabel(for index: Int) -> String {
        guard index < heatingInfos.count, let regionsInRussianForUse = MainViewViewModel.regionsInRussianForUse
            else { return "" }
        
            let heating = heatingInfos[index]
            let isHeatingAlreadyDone = heating.isDayXToday == 1 ? true : false
            let thereIsAHeatingDate = heating.date != nil ? true : false
            let translatedCity = regionsInRussianForUse[index]
            //no prognosis
            if isHeatingAlreadyDone || !thereIsAHeatingDate {
                return shortCityLabel(for: translatedCity)
            }
            //prognosis
            if thereIsAHeatingDate && !isHeatingAlreadyDone {
                return longCityLabel(for: translatedCity, and: heating)
            }
            return ""
    }
   
    func dateAsString(for index: Int) -> String {
        guard index < heatingInfos.count else { return "" }
            let heating = heatingInfos[index]
            let isHeatingAlreadyDone = heating.isDayXToday == 1 ? true : false
            let thereIsAHeatingDate = heating.date != nil ? true : false
    
            //too early for prognosis
            if !isHeatingAlreadyDone && !thereIsAHeatingDate {
                return shortDateLabel(for: heating)
            }
            //too late for prognosis
            if isHeatingAlreadyDone && thereIsAHeatingDate {
                return dateExpired(for: heating)
            }
            //if there is a prognosis
            if !isHeatingAlreadyDone && thereIsAHeatingDate {
                guard let date = heating.date else { return "" }
                return MainViewViewModel.dateFormatter.string(from: date)
            }
        return ""
    }
    
    func daysRemained(for index: Int) -> String {
        guard index < heatingInfos.count else { return "" }
        let heating = heatingInfos[index]
        let isHeatingAlreadyDone = heating.isDayXToday == 1 ? true : false
        let thereIsAHeatingDate = heating.date != nil ? true : false
        
        let differrenceInDays: Int? = {
            guard let date = heating.date, let tmpDifferenceInDays = MainViewViewModel.calendar.dateComponents([.day], from: MainViewViewModel.todayDate, to: date).day else { return nil }
            return tmpDifferenceInDays + 1
        }()
        
        //if there is a prognosis
        if !isHeatingAlreadyDone && thereIsAHeatingDate {
            return remainedDaysLabel(with: differrenceInDays)
        } else { return "" }
    }
    
    //MARK: - Helpers
    
    private func longCityLabel(for city: String, and heating: Heating) -> String {
        if city.hasPrefix("Влади") && heating.season == "spring"  {
            return "Отопление во \(city) отключится"
        } else if city.hasPrefix("Влади") && heating.season != "spring" {
            return "Отопление во \(city) включится"
        } else if !city.hasPrefix("Влади") && heating.season == "spring" {
            return "Отопление в \(city) отключится"
        } else { return "Отопление в \(city) включится" }
    }
    
    private func shortCityLabel(for city: String) -> String {
        let label = city.hasPrefix("Влади") ? "Во \(city)" : "В \(city)"
        return label
    }
    
    private func dateExpired(for heating: Heating) -> String {
        guard let date = heating.date else { return "" }
            let dateAsString = MainViewViewModel.dateFormatter.string(from: date)
            if heating.season == "spring" {
                return "отопление должны были отключить \(dateAsString)"
            } else {
                return "отопление должны были включить \(dateAsString)"
            }
    }
    
    private func shortDateLabel(for heating: Heating) -> String {
        if heating.season == "spring" {
            return "отопление в ближайшую неделю не отключат"
        } else {
            return "отопление в ближайшую неделю не включат"
        }
    }
    
    private func remainedDaysLabel(with differrenceInDays: Int?) -> String {
        guard let differrenceInDays = differrenceInDays else { return "" }
            switch differrenceInDays {
                case ..<0 : return ""
                case 0: return "Сегодня"
                case 1: return "Завтра"
                case 2: return "Послезавтра"
                case 3...4: return "Через \(differrenceInDays) дня"
                case 5...20: return "Через \(differrenceInDays) дней"
            default: return defaultRemainedDaysLabel(with: differrenceInDays)
            }
    }
    
    private func defaultRemainedDaysLabel(with differrenceInDays: Int) -> String {
        let daysToString = String(differrenceInDays)
        if daysToString.hasSuffix("1") {
            return "Через \(differrenceInDays) день"
        } else if daysToString.hasSuffix("2") || daysToString.hasSuffix("3") || daysToString.hasSuffix("4") {
            return "Через \(differrenceInDays) дня"
        } else { return "Через \(differrenceInDays) дней" }
    }
    
    //MARK: - Time-Consuming objects
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "RU_ru")
        return dateFormatter
    }()
    
    static let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "ru_RU")
        return cal
    }()
    
    static let todayDate: Date = {
        let today = Date()
        return today
    }()
    
    static let regionsInRussianForUse: [String]? = {
        do {
            if let path = Bundle.main.path(forResource: "regions_for_use", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: .utf8)
                let tmpRegionsInRussianForUse = data.components(separatedBy: "\n")
                return tmpRegionsInRussianForUse
            }
        } catch let err as NSError { print(err) }
        return nil
    }()
    
    static let regionsInEnglish: [String]? = {
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
