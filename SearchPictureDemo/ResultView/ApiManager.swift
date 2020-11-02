//
//  ApiManager.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 28/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

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

    func getData() {
        /*
        https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=e7ea248224929fea196315b753b2a3ca&text=dog&max_taken_date=5&media=photos&format=rest
        */
        
        guard let url = URL(string: "https://www.flickr.com/services") else { return }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "", value: "")]
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = "GET"
       
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, rsp, error) in

            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            do {
                let array = try XMLDecoder().decode(Rsp.self, from: data)
                print(array)
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()

    }
}
