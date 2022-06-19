//
//  NetworkManager.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

class NetworkManager: NetworkManagerContext {
    
    private let requestConfiguration = RequestConfiguration()
    
    func loadData<T: Codable>(completionHandler: @escaping (Result<T, AppError>) -> Void) {
        
        guard let url = requestConfiguration.buildURL(),
              let bundleIdentifier =  Bundle.main.bundleIdentifier else { return }
        
        var request = URLRequest(url: url)
        request.setValue(bundleIdentifier, forHTTPHeaderField: requestConfiguration.httpHeader)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.networkIssue))
                return
            }

            do {
                let spreadsheet = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(spreadsheet))
            } catch {
                completionHandler(.failure(.networkIssue))
            }
        }.resume()
    }
}
