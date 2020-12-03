//
//  EndPoint.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 3/12/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation

protocol ApiRequestable {
    var baseURL: String { get }
    var path: [URLQueryItem] { get }
    var httpMethod: String { get }
}

protocol ApiConfigurating {
    var baseURL: String { get }
    var httpMethod: String { get }
}

struct ApiConfig: ApiConfigurating {

    var baseURL: String {
        return "https://www.flickr.com/services/rest/"
    }

    var httpMethod: String {
        return "GET"
    }
}

struct SPDApi<T: ApiConfigurating> {

    private var config: T
    private var apiType: ApiType

    var requestModel: Codable {
        get {
            switch apiType {
            case .searchPicture(let model):
                return model
            }
        }
    }

    init(config: T, apiType: ApiType) {
        self.config = config
        self.apiType = apiType
    }

    func makeQuerys() -> [URLQueryItem] {
        let modelDict = requestModel.dictionary
        var querys: [URLQueryItem] = []
        let keys = modelDict.keys
        for key in keys {
            if let value = modelDict["\(key)"] as? String {
                let query = URLQueryItem(name: key, value: value)
                querys.append(query)
            }
        }
        return querys
    }

}

extension SPDApi: ApiRequestable {
    var baseURL: String {
        return self.config.baseURL
    }

    var httpMethod: String {
        return self.config.httpMethod
    }

    var path: [URLQueryItem] {
        return self.makeQuerys()
    }

}

//MARK: - Make Dictionary from Model
fileprivate struct JSON {
    static let encoder = JSONEncoder()
}

fileprivate extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
