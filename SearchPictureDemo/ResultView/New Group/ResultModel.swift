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
}
