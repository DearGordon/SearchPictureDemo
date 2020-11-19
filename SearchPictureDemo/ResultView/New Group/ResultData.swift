//
//  ResultData.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 18/11/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation
import CoreData

class ResultData: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var url: String?
}

extension ResultData: ResultDataProtocol {
    var pictureTitle: String {
        return title ?? "測試"
    }

    var pictureUrl: String? {
        return url ?? "https://live.staticflickr.com/65535/50536401813_1070fcacc5.jpg"
    }
}
