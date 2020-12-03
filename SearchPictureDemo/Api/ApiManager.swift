//
//  ApiManager.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 28/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

class ApiManager {

    static var shared = ApiManager()

    private init() {}
    
    func getData(api: ApiType, completion: @escaping ((Result<[Photo]?, SPDError>) -> Void))  {

        let session = URLSession(configuration: .default)

        guard let request = self.request(api: api) else {
            completion(.failure(SPDError(message: "creat request fail")))
            return
        }

        let task = session.dataTask(with: request) { (data, rsp, error) in

            guard let data = data else {
                completion(.failure(SPDError(message: "No response data", originalError: error)))
                return
            }
            
            self.xmlDecoder(with: data) { (result) in
                switch result {
                case .success(let rsp):
                    completion(.success(rsp.photos?.photo))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    private func xmlDecoder(with data: Data, completion: ((Result<Rsp, SPDError>) -> Void)) {
        do {
            let rsp = try XMLDecoder().decode(Rsp.self, from: data)
            completion(.success(rsp))
        } catch {
            let nsError = error as NSError
            completion(.failure(SPDError(message: nsError.description, originalError: error)))
        }
    }

    private func request(api: ApiType) -> URLRequest? {
        let config = ApiConfig()
        let spdApi = SPDApi(config: config, apiType: api)
        return URLRequest.request(api: spdApi)
    }
}

extension URLRequest {
    static func request(api: ApiRequestable) -> URLRequest? {

        let baseUrl = URL(string: api.baseURL)!
        guard var urlComponse = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { return nil }
        urlComponse.queryItems = api.path
        return URLRequest(url: urlComponse.url!)
    }
}
