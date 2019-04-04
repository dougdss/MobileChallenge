//
//  ApiClient.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 04/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case invalidData
    case parse
    
    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "The data used for the parse was invalid"
        case .parse:
            return "Could not parse the response"
        }
    }
}

struct ApiParseError: Error {
    
    var data: Data?
    var httpUrlResponse: HTTPURLResponse?
    var error: Error?
    
    var localizedDescription: String {
        return error?.localizedDescription ?? "could not parse response"
    }
}

struct ApiError: Error {
    
    var data: Data?
    var httpUrlResponse: HTTPURLResponse?
    var error: Error?
    
    var localizedDescription: String {
        return error?.localizedDescription ?? "Unknow Error, did not received a success status code"
    }
}

struct NetworkError: Error {
    
    let error: Error?
    
    var localizedDescription: String {
        return error?.localizedDescription ?? "unknow network error"
    }
    
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct ApiResponse<T: Decodable> {
    
    var data: Data?
    var httpUrlResponse: HTTPURLResponse?
    var entity: T?
    
    init(data: Data?, httpResponse: HTTPURLResponse?) throws {
        self.data = data
        self.httpUrlResponse = httpResponse
        
        do {
            self.entity = try parseEntity()
        } catch {
            throw ApiParseError(data: data, httpUrlResponse: httpResponse, error: error)
        }
    }
    
    func parseEntity() throws -> T {
        guard let validData = self.data else {
            throw ApiParseError(data: self.data, httpUrlResponse: self.httpUrlResponse, error: ParseError.invalidData)
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: validData)
        return decoded
    }
    
    
}

protocol ApiRequest {
    var urlRequest: URLRequest { get }
}

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
                    completionHandler(.failure(ApiParseError(data: data, httpUrlResponse: httpUrlResponse, error: error)))
                }
            } else {
                completionHandler(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse, error: error)))
            }
        }
        dataTask.resume()
    }
  

}



