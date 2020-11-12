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
    
    private func getFavoritResult(completion: (() -> Void)) {
        
    }

    private func getSearchResult(searchInfo: SearchInfo, completion: @escaping (() -> Void)) {

        do {
            try ApiManager.shared.getData(searchInfo: searchInfo, completion: { (result) in
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

extension ResultViewModel: ResultViewModelProtocol {

    var resultArray: [ResultDataProtocol] {
        return dataArray
    }

    var numberOfItemsInSection: Int {
        return dataArray.count
    }

    func getPhotosData(by mode: ResultViewControllerMode, completion: @escaping (() -> Void)) {
        
        switch mode {
        case .Searching(searchInfo: let searchInfo):
            self.getSearchResult(searchInfo: searchInfo) {
                completion()
            }
        case .Favorited:
            self.getFavoritResult {
                completion()
            }
        }
    }

}
