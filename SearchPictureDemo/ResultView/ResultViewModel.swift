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

class ResultViewModel {

    var dataArray: [ResultDataProtocol] = []

    weak var delegate: ResultViewModelDelegate?

    init(withDelegate delegate: ResultViewModelDelegate) {
        self.delegate = delegate
    }



}

extension ResultViewModel: ResultViewModelProtocol {

    var resultArray: [ResultDataProtocol] {
        return dataArray
    }

    var numberOfItemsInSection: Int {
        return dataArray.count
    }

    func getData(text: String, perPage: Int, page: Int, completion: @escaping (() -> Void)) {

        do {
            try ApiManager.shared.getData(text: text, perPage: perPage, page: page, completion: { (result) in
                switch result {
                case .success(let data):
                    guard let data = data else { return }
                    self.dataArray = data
                case .failure(let error):
                    print(error.localizedDescription)
                }
                completion()
            })

        } catch {
            print(error)
        }


    }

}
