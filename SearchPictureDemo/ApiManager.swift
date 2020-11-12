//
//  ApiManager.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 28/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMeth { get }
}

enum HTTPMeth: String {
    case get  = "GET"
    case post = "POST"
}

enum NetworkError: String, Error {
    case missingURL = "URL is nil."
}

enum FlickrRequest {
    case photoSearch(searchInfo: SearchInfo)
    
    func querys() -> [URLQueryItem] {
        var querys: [URLQueryItem] = []
        
        switch self {
        case .photoSearch(searchInfo: let search):
            querys.append(query(name: "text", value: search.text))
            querys.append(query(name: "per_page", value: "\(search.perPage)"))
            querys.append(query(name: "page", value: "\(search.page)"))
        }
        return querys
    }
    
    private func query(name: String, value: String) -> URLQueryItem {
        return URLQueryItem(name: name, value: value)
    }
}

class ApiManager {

    static var shared = ApiManager()
    private var session = URLSession(configuration: .default)

    private init() {}
    
    func getData(searchInfo: SearchInfo, completion: @escaping ((Result<[Photo]?, Error>) -> Void)) throws {

        guard let url = URL(string: "https://www.flickr.com/services/rest/") else { throw NetworkError.missingURL }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: "e7ea248224929fea196315b753b2a3ca"),
                                     URLQueryItem(name: "format", value: "rest"),
                                     URLQueryItem(name: "method", value: "flickr.photos.search")
        ]
        let querys = FlickrRequest.photoSearch(searchInfo: searchInfo).querys()

        for query in querys {
            urlComponents?.queryItems?.append(query)
        }

        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = "GET"
       
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, rsp, error) in

            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            do {
                let rsp = try XMLDecoder().decode(Rsp.self, from: data)

                if let count = rsp.photos?.photo?.count {
                    print("下載了\(count)筆資料")
                }

                completion(.success(rsp.photos?.photo))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
