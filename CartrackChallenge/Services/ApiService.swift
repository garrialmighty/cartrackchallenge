//
//  ApiService.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

final class ApiService {
    
    static let shared = ApiService()
    typealias NetworkResult = (Result<[Car], NetworkError>) -> Void
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    private init() {
    }
    
    func fetchCars(page: Int = 0, completion: @escaping NetworkResult)  {
        guard var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(.badURL))
            return
        }
        
        component.path = "/users"
        component.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        guard let requestURL = component.url else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let cars = try decoder.decode([Car].self, from: data)
                        completion(.success(cars))
                    } catch {
                        completion(.failure(.requestFailed))
                    }
                } else if let _ = error {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }
        .resume()
    }
}
