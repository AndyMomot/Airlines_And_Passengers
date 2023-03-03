//
//  TestNetworkService.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 23.9.22.
//

import Foundation

class NetworkService {
    
    static private var baseURL: String {
        guard let info = Bundle.main.infoDictionary,
              let urlString = info["Base URL"] as? String else {
            fatalError("Cannot get base url from info.plist")
        }
        return urlString
    }
    
    // completionHandler executes NOT in the main queue
    static func request(endpoint: Endpoint, completionHandler: ((Results<Data>) -> Void)? = nil) {
        
        /// Checking internet connection
         guard Reachability.isInternetAvailable else {
             NotificationCenter.default.post(name: .InternetNotAvailable, object: nil)
             return
         }
         
         /// Creating URL
         guard let url = URL(string: baseURL + endpoint.path) else {
             print("Invalid url address", endpoint)
             return
         }
        
        /// Creating Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 30
    
        // create the session object
        let session = URLSession.shared
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
          
          if let error = error {
            print("Post Request Error: \(error)")
            return
          }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard let statusCode = statusCode, statusCode <= StatusCodes.created.rawValue else {
                var error: ResponseError
                switch statusCode {
                case StatusCodes.notFound.rawValue:
                    error = ResponseError.failed(code: .notFound, data: data)
                case StatusCodes.server.rawValue:
                    error = ResponseError.failed(code: .server, data: data)
                default:
                    error = ResponseError.failed(code: .unknownError, data: data)
                    
                }
                completionHandler?(Results.failure(error))
                return
            }
            
            guard let data = data else {
                let error = error ?? ResponseError.dataMissed
                completionHandler?(Results.failure(error))
                return
            }
            print(data)
            completionHandler?(Results.success(data))
        }
        task.resume()
    }
    
    static func postRequest(endpoint: Endpoint, completionHandler: ((Results<Data>) -> Void)? = nil) {
        
       /// Checking internet connection
        guard Reachability.isInternetAvailable else {
            NotificationCenter.default.post(name: .InternetNotAvailable, object: nil)
            return
        }
        
        /// Creating URL
        guard let url = URL(string: baseURL + endpoint.path) else {
            print("Invalid url address", endpoint)
            return
        }
        
        /// Creating Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue//ConstantsGlobal.HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(
                withJSONObject: endpoint.parameters as Any,
                options: [.prettyPrinted])
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        // create the session object
        let session = URLSession.shared
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            debugPrint(response as? HTTPURLResponse as Any)
            
            guard let statusCode = statusCode, statusCode <= StatusCodes.created.rawValue else {
                guard let data = data else {
                    print("No Data!")
                    return
                }
                
                var error: ResponseError
                switch statusCode {
                case StatusCodes.notFound.rawValue:
                    error = ResponseError.failed(code: .notFound, data: data)
                case StatusCodes.server.rawValue:
                    error = ResponseError.failed(code: .server, data: data)
                default:
                    error = ResponseError.failed(code: .unknownError, data: data)
                    
                }
                completionHandler?(Results.failure(error))
                return
            }
            
            guard let data = data else {
                let error = error ?? ResponseError.dataMissed
                completionHandler?(Results.failure(error))
                return
            }
            print(data)
            completionHandler?(Results.success(data))
        }
        task.resume()
    }
    
    
}
