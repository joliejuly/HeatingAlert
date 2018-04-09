//
//  RequestHeatingDataController.swift
//
//  Created by Julia Nikitina on 11.03.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.

import Foundation

//we need a class here, not a struct, to call a helper method in Dispatch Queue

final class RequestHeatingDataController {
    
    //enter your url with JSON data here
    static let url = URL(string: "")!
    static let jsonDecoder = JSONDecoder()
    
    typealias HeatingDataCompletion = ([Heating]?) -> Void
    
    
    func requestHeatingData(completion: @escaping HeatingDataCompletion)
    {
        let request = URLSession.shared.dataTask(with: RequestHeatingDataController.url) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                self?.didReceiveHeatingData(data: data, response: response, error: error, completion: completion)
            }
        }
        request.resume()
    }
    
    
    func didReceiveHeatingData(data: Data?, response: URLResponse?, error: Error?, completion: HeatingDataCompletion) {
        
        if let _ = error {
            completion(nil)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 { //"OK"
                do {
                    //decode JSON
                    let heatingInfo = try RequestHeatingDataController.jsonDecoder.decode([Heating].self, from: data)
                    //update UI with data
                    completion(heatingInfo)
                } catch {
                    //invalid response
                    completion(nil)
                }
            } else { //failed request
                completion(nil)
            }
        } else { //unknown error
            completion(nil)
        }
    }
}
