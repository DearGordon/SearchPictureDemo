//
//  SearchPictureRequestModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 3/12/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation

struct SearchPictureRequestModel: Codable {

    var api_key: String = "e7ea248224929fea196315b753b2a3ca"
    var format: String = "rest"
    var method: String = "flickr.photos.search"
    var text: String
    var per_page: String
    var page: String

    internal init(text: String, per_page: Int, page: Int) {
        self.text = text
        self.per_page = "\(per_page)"
        self.page = "\(page)"
    }
}
