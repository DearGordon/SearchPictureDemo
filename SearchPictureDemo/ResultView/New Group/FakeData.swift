//
//  FakeData.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 12/11/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

struct FakeData {
    var title: String = "測試"
    var picture: String = "https://live.staticflickr.com/65535/50536401813_1070fcacc5.jpg"
}

extension FakeData: ResultDataProtocol {
    var pictureTitle: String {
        return title
    }

    var pictureUrl: String? {
        return picture
    }
}
