//  Heating.swift
//
//  Created by Julia Nikitina on 11.03.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.

import Foundation

struct Heating: Codable {
    
    var city: String
    var jsonDate: String?
    var season: String //fall or spring
    var isDayXToday: Int //if heating was already turned off/on
    
    var date: Date? {
        guard let jsonDate = jsonDate, let estimatedDate = Heating.isoDateFormatter.date(from: jsonDate)
            else { return nil }
        return estimatedDate
    }
    
    //MARK: - JSON

    //to match JSON values
    enum CodingKeys: String, CodingKey {
        case city = "latin"
        case jsonDate = "heating_date"
        case season
        case isDayXToday = "last_date"
    }
    
    //convert JSON to Heating
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try valueContainer.decode(String.self, forKey: CodingKeys.city)
        self.jsonDate = try? valueContainer.decode(String.self, forKey: CodingKeys.jsonDate)
        self.season = try valueContainer.decode(String.self, forKey: CodingKeys.season)
        self.isDayXToday = try valueContainer.decode(Int.self, forKey: CodingKeys.isDayXToday)
    }
    
    
    //MARK: - time-consuming objects
    
    //NOTE: time-consuming objects are static to make sure they are created only once
    
    //we need ISO8601DateFormatter, because in JSON dates are "2016-23-08", and DateFormatter can't read them
    static let isoDateFormatter: ISO8601DateFormatter = {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withDashSeparatorInDate, .withFullDate]
        return isoFormatter
    }()

    //reads a list of region names from txt file to an array
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
    
    //MARK: - saving data on disk
    
    //recovers user's preferred city from the last session
    static var savedCity: String? = {
        guard let tmpCity = UserDefaults.standard.object(forKey: "savedCity") as? String
            else { return nil }
        return tmpCity
    }()
    
    //to save a new chosen city from current session
    static var selectedCity: String?
    
    static func saveDataOnDisk() {
        guard let newSelectedCity = Heating.selectedCity else { return }
        UserDefaults.standard.set(newSelectedCity, forKey: "savedCity")
        
    }
}
