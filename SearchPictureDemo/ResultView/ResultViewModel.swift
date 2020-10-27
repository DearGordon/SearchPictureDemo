//
//  ResultViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol ResultViewModelDelegate: class {

}

struct ResultData {
    var image: UIImage
    var text: String
}

extension ResultData: ResultDataProtocol {

    var title: String {
        return text
    }

    var picture: UIImage {
        return image
    }
}

class ResultViewModel {

    var dataArray: [ResultDataProtocol] = []

    weak var delegate: ResultViewModelDelegate?

    init(withDelegate delegate: ResultViewModelDelegate) {
        self.delegate = delegate
        self.makeFakeData()
    }

    func makeFakeData() {
        let image = UIImage(named: "hamburger")!
        let text = "測試"

        let data = ResultData(image: image, text: text)
        for _ in 0...9 {

            dataArray.append(data)
        }
    }
}

extension ResultViewModel: ResultViewModelProtocol {

    var resultArray: [ResultDataProtocol] {
        return dataArray
    }

    var numberOfItemsInSection: Int {
        return dataArray.count
    }

}
