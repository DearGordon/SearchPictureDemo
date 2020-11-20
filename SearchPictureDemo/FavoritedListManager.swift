//
//  FavoritedListManager.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 19/11/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import Foundation

class FavoritedListManager {

    static var shared = FavoritedListManager()

    private init() {}

    var favoritedList: [ResultDataProtocol] = []

    func getFavoritResult(completion: @escaping (() -> Void)) {

        CoreDataHelper.shared.loadResultData { (result) in
            switch result {
            case .success(let resultDatas):
                self.favoritedList = resultDatas
            case .failure(_):
                print("我沒有拿到值")
            }

            completion()
        }
    }

    private func hasSameData(with data: ResultDataProtocol) -> Int? {
        //無法使用Array.contein,因為無法服從Equatable，not object
        for i in 0..<favoritedList.count {
            if data.pictureUrl == favoritedList[i].pictureUrl {
                return i
            }
        }
        return nil
    }

    func favoritedAction(with data: ResultDataProtocol) {
        guard let dataIndex = self.hasSameData(with: data) else {
            self.favoritedList.append(data)
            return
        }
        self.favoritedList.remove(at: dataIndex)
    }

}
