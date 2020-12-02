//
//  ResultCollectionViewCellViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordan_Feng on 2020/11/13.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation


class ResultCollectionViewCellViewModel {

    private var imageUrl: String
    private var dataTitle: String
    
    private var resultData: ResultDataProtocol

    init(resultData: ResultDataProtocol) {
        self.resultData = resultData
        self.imageUrl = resultData.pictureUrl ?? ""
        self.dataTitle = resultData.pictureTitle
    }

    private func checkFavorited() -> Bool {

        guard FavoritedListManager.shared.hasSameDataIndex(with: self.resultData) != nil else {
            return false
        }
        return true
    }

    private func favoritedAction() {
        FavoritedListManager.shared.favoritedAction(with: self.resultData)
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

    func favoritedButtonPressed(completion: (() -> Void)) {
        self.favoritedAction()
        completion()
    }
}
