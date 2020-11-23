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
    private func getFavoritResult(completion: @escaping (() -> Void)) {
        FavoritedListManager.shared.getFavoritListFromCoreData(completion: {
            self.dataArray = FavoritedListManager.shared.favoritedList
            completion()
        })
    }

    func setFakeData() {
        var fakeDataArray: [ResultData] = []

        for _ in 0...4 {
            let moc = CoreDataHelper.shared.managedObjectContext()
            let result = ResultData(context: moc)
            result.title = "測試照片title"
            result.url = "https://live.staticflickr.com/65535/50536401813_1070fcacc5.jpg"
            fakeDataArray.append(result)
        }
        self.dataArray = fakeDataArray
        CoreDataHelper.shared.saveContext(completion: nil)
    }

}

extension FavoritedViewModel: ResultViewModelProtocol {

    var resultArray: [ResultDataProtocol] {
        //TODO: 不能這樣做，因為要等待resultArray取得資料會有時間差
        return self.dataArray
    }

    var numberOfItemsInSection: Int {
        return self.dataArray.count
    }

    func getPhotosData(isTurnPage: Bool, completion: @escaping (() -> Void)) {
        if isTurnPage { return }
        self.getFavoritResult {
            completion()
        }
    }

    
}
