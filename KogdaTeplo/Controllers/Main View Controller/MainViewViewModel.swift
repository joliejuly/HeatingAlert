//
//  MainViewViewModel.swift
//  KogdaTeplo
//
//  Created by Yulia Taranova on 07.04.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import Foundation
enum RequestResult {
    case success
    case error
}
final class MainViewViewModel {
    private enum PrognosisState {
        case tooEarly
        case tooLate
        case actual
        case none
    }
    var didFinishDataRequest: ((RequestResult) -> Void)?
    
    var heatingInfos: [HeatingInfo]?
    var heatingObject: HeatingInfo? {
        willSet {
            prognosisState = getPrognosisState(from: newValue)
        }
    }
    var selectedCity: String? {
        willSet {
           guard let newValue = newValue,
            let index = DataSource.shared
                .regionsInRussian?.index(of: newValue)
            else { return }
            heatingObject = heatingInfo(at: index)
        }
    }
    
    var savedCity: String {
        guard let saved = HeatingInfo.savedCity,
        let index = DataSource.shared
            .regionsInRussian?.index(of: saved)
            else { return "Москва" }
        heatingObject = heatingInfo(at: index)
        return saved
    }
    
    private var prognosisState = PrognosisState.none

    func fetchHeatingData() {
        RequestHeatingDataController.shared
            .requestHeatingData() { [weak self] response in
            guard let self = self else { return }
            if let response = response {
                self.heatingInfos = response
                self.didFinishDataRequest?(.success)
            } else {
                self.didFinishDataRequest?(.error)
            }
        }
    }

    func textForCityLabel(for city: String) -> String {
        guard
            let index = DataSource.shared
            .regionsInRussian?.index(of: city),
            let regionsInRussianForUse =
            DataSource.shared.regionsInRussianForUse
            else { return "Москва" }
        if heatingInfos == nil,
            let regions = DataSource.shared.regionsInRussian {
            return regions[index]
        }
        return cityTextWithPreposition(
            from: regionsInRussianForUse[index])
    }

    //date label
    func dateAsString() -> String {
        guard let heating = heatingObject,
            let date = heating.date else { return "" }
        let stringDate = DataSource.shared
            .dateFormatter.string(from: date)
        switch prognosisState {
        case .none:
            return ""
        case .tooLate:
            return tooLatePrognosis(
                for: heating.season,
                and: stringDate)
        case .tooEarly:
            return tooEarlyPrognosis(
                for: heating.season)
        case .actual:
            return prognosis(
                for: heating.season,
                and: stringDate)
        }
    }

    func daysRemained() -> String {
        guard let heating = heatingObject
            else { return "" }
        if prognosisState == .actual {
            guard let differenceInDays =
                countDifferenceInDaysBetweenToday(
                    and: heating.date)
                else { return "" }
            return createText(for: differenceInDays)
        }
        return ""
    }
}


//MARK: - Helpers
extension MainViewViewModel {

    private func heatingInfo(
        at index: Int) -> HeatingInfo? {
        guard let heatingInfos = heatingInfos,
            index < heatingInfos.count
            else { return nil }
        return heatingInfos[index]
    }
    
    private func cityTextWithPreposition(
        from cityText: String) -> String {
        if cityText.hasPrefix("Влади") {
            return "Во \(cityText)"
        } else {
            return "В \(cityText)"
        }
    }
    
    private func defaultString(for differenceInDays: Int) -> String {
        let daysToString = String(differenceInDays)
        if daysToString.hasSuffix("1") {
            return "Через \(differenceInDays) день"
        } else if daysToString.hasSuffix("2")
            || daysToString.hasSuffix("3")
            || daysToString.hasSuffix("4") {
            return "Через \(differenceInDays) дня"
        } else {
            return "Через \(differenceInDays) дней"
        }
    }

    private func countDifferenceInDaysBetweenToday(
        and date: Date?) -> Int? {
        guard let date = date,
            let differenceInDays =
            DataSource.shared.calendar
                .dateComponents([.day],
                                from: DataSource.shared.todayDate,
                                to: date).day
            else { return nil }
        return differenceInDays + 1
    }
    
    private func createText(for differenceInDays: Int) -> String {
        switch differenceInDays {
        case ..<0 : return ""
        case 0: return "Сегодня"
        case 1: return "Завтра"
        case 2: return "Послезавтра"
        case 3...4: return "Через \(differenceInDays) дня"
        case 5...20: return "Через \(differenceInDays) дней"
        default:
            return defaultString(for: differenceInDays)
        }
    }
    
    private func getPrognosisState(
        from heating: HeatingInfo?) -> PrognosisState {
        guard let heating = heating
            else { return .none }
        let isHeatingAlreadyDone =
            heating.isDayXToday == 1 ? true : false
        let thereIsAHeatingDate =
            heating.date != nil ? true : false
        let tooEarlyForPrognosis =
            !isHeatingAlreadyDone && !thereIsAHeatingDate
        let tooLateForPrognosis =
            isHeatingAlreadyDone && thereIsAHeatingDate
        let thereIsAPrognosis =
            !isHeatingAlreadyDone && thereIsAHeatingDate
        
        if tooEarlyForPrognosis {
            return .tooEarly
        }
        if tooLateForPrognosis {
            return .tooLate
        }
        if thereIsAPrognosis {
            return .actual
        }
        return .none
    }
    
    private func tooLatePrognosis(for season: String,
                                  and date: String) -> String {
        if season == "spring"  {
            return "отопление должны были отключить \(date)"
        } else {
            return "отопление должны были включить \(date)"
        }
    }
    
    private func tooEarlyPrognosis(for season: String) -> String {
        if season == "spring" {
            return "отопление в ближайшую неделю не отключат"
        } else {
            return "отопление в ближайшую неделю не включат"
        }
    }
    
    private func prognosis(for season: String,
                           and date: String) -> String {
        if season == "spring"  {
            return "отопление отключится \(date)"
        } else {
            return "отопление включится \(date)"
        }
    }
}
