import Foundation

typealias HeatingDataCompletion = ([HeatingInfo]?) -> Void

final class RequestHeatingDataController {
    
    //ask me via julianikitina.ios@gmail.com to provide the url 
    static let url = URL(string: "")!
    static let jsonDecoder = JSONDecoder()

    static let shared = RequestHeatingDataController()
    
    lazy var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.waitsForConnectivity = true
        return URLSession(configuration: sessionConfiguration)
    }()
    
    func requestHeatingData(completion: @escaping HeatingDataCompletion)
    {
        // Create Data Task
        let request = session.dataTask(with: RequestHeatingDataController.url) { [weak self] data, response, error  in
    
            self?.didReceiveHeatingData(data: data, response: response, error: error, completion: completion)
        }
        request.resume()
    }
    
    func didReceiveHeatingData(data: Data?, response: URLResponse?, error: Error?, completion: HeatingDataCompletion) {
        
        if let error = error {
            print(error)
            completion(nil)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    //decode JSON
                    let heatingInfo = try RequestHeatingDataController.jsonDecoder.decode([HeatingInfo].self, from: data)
                    completion(heatingInfo)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}
