//
//  FavorritedViewModel.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 12/11/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

class FavoritedViewModel: NSObject {

    private var dataArray: [ResultDataProtocol] = []

    /// 從我的最愛中下載下來
    /// - Parameter completion: 下載完我的最愛後
    private func getFavoritResult(completion: (() -> Void)) {
        for _ in 0...4 {
            dataArray.append(FakeData())
        }
        
    }

}

extension FavoritedViewModel: ResultViewModelProtocol {
    var resultArray: [ResultDataProtocol] {
        return self.dataArray
    }

    var numberOfItemsInSection: Int {
        return self.dataArray.count
    }

    func getPhotosData(completion: @escaping (() -> Void)) {
        
        self.getFavoritResult {
            completion()
        }
    }

    
}
