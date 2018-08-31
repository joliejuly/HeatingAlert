//
//  PhotoInfoCOntroller.swift
//  SpacePhotoJSONLesson
//
//  Created by Yulia Taranova on 08.03.2018.
//  Copyright © 2018 Yulia Taranova. All rights reserved.
//

import Foundation

 struct PhotoInfoController {
    
    func fetchPhotoInfo(completion: @escaping (PhotoInfo?) -> Void)
    {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        
        let query = [
            "api_key": "uLCDsIPefx1ZVIhfeIbE5HFVNp2kspB1TspbBRYh",
            "date": "2000-01-01"
        ]
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) {
            
            (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data, let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data)
            {
                completion(photoInfo)
            }
            else
            {
                print("Error")
                completion(nil)
            }
            
        }
        
        task.resume()
        
    }
    
    
}
