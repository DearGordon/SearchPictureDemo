//
//  ResultModel.swift
//  SearchPictureDemo
//
//  Created by Gordan_Feng on 2020/11/2.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation

struct Rsp: Codable {
    var photos: Photos?
}

struct Photos: Codable {
    
    var photo: [Photo]?
}

struct Photo: Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: String?
    var isfriend: String?
    var isfamily: String?
    

    func photoURL() -> String? {
        //https://live.staticflickr.com/{server-id}/{id}_{secret}_{size-suffix}.jpg
        guard let server = server, let id = id, let secret = secret else { return nil }
        let urlString = "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg"
        return urlString
    }
}

extension Photo: ResultDataProtocol {
    var pictureTitle: String {
        return title ?? "empty text"
    }

    var pictureUrl: String? {
        return photoURL()
    }

}
