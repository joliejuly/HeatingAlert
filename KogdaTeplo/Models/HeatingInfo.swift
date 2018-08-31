//
//  Heating.swift
//  SpacePhotoJSONLesson
//
//  Created by Yulia Taranova on 11.03.2018.
//  Copyright © 2018 Yulia Taranova. All rights reserved.
//

import Foundation

struct HeatingInfo: Codable, Equatable {
    
    var city: String
    var jsonDate: String?
    var season: String
    var isDayXToday: Int
    
    var date: Date? {
        if let jsonDate = jsonDate, let estimatedDate = HeatingInfo.isoDateFormatter.date(from: jsonDate) {
            return estimatedDate
        } else {
            return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case city = "latin"
        case jsonDate = "heating_date"
        case season
        case isDayXToday = "last_date"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try valueContainer.decode(String.self, forKey: CodingKeys.city)
        self.jsonDate = try? valueContainer.decode(String.self, forKey: CodingKeys.jsonDate)
        self.season = try valueContainer.decode(String.self, forKey: CodingKeys.season)
        self.isDayXToday = try valueContainer.decode(Int.self, forKey: CodingKeys.isDayXToday)
    }
    
    static func ==(lhs: HeatingInfo, rhs: HeatingInfo) -> Bool {
        return lhs.city == rhs.city
    }
    
    static let isoDateFormatter: ISO8601DateFormatter = {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withDashSeparatorInDate, .withFullDate]
        return isoFormatter
    }()

   
    static let regionsInRussian: [String]? = {
        do {
            if let path = Bundle.main.path(forResource: "regions", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: .utf8)
                let tmpRegionsInRussianForUse = data.components(separatedBy: "\n")
                return tmpRegionsInRussianForUse
            }
        } catch let err as NSError { print(err) }
        return nil
    }()
    
    static var savedCity: String? = {
        guard let tmpCity = UserDefaults.standard.object(forKey: "savedCity") as? String
            else { return nil }
        return tmpCity
    }()
    
    static var estimatedDate: String? = {
        guard let tmpEstimatedDate = UserDefaults.standard.object(forKey: "estimatedDate") as? String
            else { return nil }
        return tmpEstimatedDate
    }()
    
    static var selectedCity: String?

    
    static func saveDataOnDisk() {
        guard let newSelectedCity = HeatingInfo.selectedCity else { return }
        UserDefaults.standard.set(newSelectedCity, forKey: "savedCity")
        
    }
    
    
}
