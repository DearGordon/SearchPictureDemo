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
    
    init(withDelegate delegate: ResultCollectionViewCellViewModelDelegate) {
        self.delegate = delegate
    }
    
    func favoritedAction() {
        
    }
}
