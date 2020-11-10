//
//  ApiManager.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 28/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

enum QueryItem {
    case text(text: String)
    case per_page(count: Int)
    case page(number: Int)

    func query() -> URLQueryItem {
        switch self {
        case .text(text: let text):
            return URLQueryItem(name: "text", value: text)
        case .per_page(count: let count):
            return URLQueryItem(name: "per_page", value: "\(count)")
        case .page(number: let number):
            return URLQueryItem(name: "page", value: "\(number)")
        }
    }
}

enum FlickrRequest {
    case photoSearch([QueryItem])

    func url() {

    }
}

class ApiManager {

    //key： e7ea248224929fea196315b753b2a3ca
    //密鑰： be10ecd3e7c6640a

    static var shared = ApiManager()
    private var session = URLSession(configuration: .default)

    private init() {}

    struct ResquestModel: Codable {
        var api_key: String = "e7ea248224929fea196315b753b2a3ca"
        var text: String = "dog"
        var max_taken_date: Int = 5
        var media = "photos"
    }

    func getData(completion: @escaping ((Result<[Photo]?, Error>) -> Void)) {

        guard let url = URL(string: "https://www.flickr.com/services/rest/") else { return }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: "e7ea248224929fea196315b753b2a3ca"),
                                     URLQueryItem(name: "format", value: "rest"),
                                     URLQueryItem(name: "method", value: "flickr.photos.search")
        ]
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
