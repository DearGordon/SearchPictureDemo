//
//  FavorritedViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 12/11/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

class FavoritedViewModel: NSObject {

    /// 從我的最愛中下載下來
    /// - Parameter completion: 下載完我的最愛後
    private func getFavoritResult(completion: (() -> Void)) {

    }

}

extension FavoritedViewModel: ResultViewModelProtocol {
    var resultArray: [ResultDataProtocol] {
        let array: [ResultDataProtocol] = []
        return array
    }

    var numberOfItemsInSection: Int {
        return 1
    }

    func getPhotosData(completion: @escaping (() -> Void)) {
        
        self.getFavoritResult {
            completion()
        }
    }

    
}
