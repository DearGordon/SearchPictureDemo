//
//  ResultCollectionViewCellViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordan_Feng on 2020/11/13.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation

protocol ResultCollectionViewCellViewModelDelegate: class {
    func setFavoritedStatus(isLike: Bool)
}

class ResultCollectionViewCellViewModel {
    
    weak var delegate: ResultCollectionViewCellViewModelDelegate?

    private var imageUrl: String
    private var dataTitle: String

    init(resultData: ResultDataProtocol) {
        self.imageUrl = resultData.pictureUrl ?? ""
        self.dataTitle = resultData.pictureTitle
    }

    private func checkFavorited() -> Bool {
        //TODO: check is favorited or not
        return true
    }

    private func addFavorited() {
        
    }

    private func removeFavorited() {

    }
    
}

extension ResultCollectionViewCellViewModel: ResultCellViewModel {

    var pictureUrl: String {
        return self.imageUrl
    }

    var title: String {
        return self.dataTitle
    }

    var isFavorited: Bool {
        return self.checkFavorited()
    }

    func favoritedAction(completion: ((Bool) -> Void)) {
        if isFavorited {
            self.removeFavorited()
            completion(false)
        } else {
            self.addFavorited()
            completion(true)
        }
    }
}
