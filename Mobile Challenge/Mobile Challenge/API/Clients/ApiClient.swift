//
//  ApiClient.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

protocol ApiService {
    func execute<T>(request: ApiRequest, completionHandler: @escaping (Result<ApiResponse<T>>) -> Void)
}

class ApiClient: ApiService {
    
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
    }
  
    func execute<T>(request: ApiRequest, completionHandler: @escaping (Result<ApiResponse<T>>) -> Void) where T : Decodable {
        let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(NetworkError(error: error)))
                return
            }
            
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) {
                do {
                    let jsonResponse = try ApiResponse<T>(data: data, httpResponse: httpUrlResponse)
                    completionHandler(.success(jsonResponse))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse, error: error)))
            }
        }
        dataTask.resume()
    }
  

}



