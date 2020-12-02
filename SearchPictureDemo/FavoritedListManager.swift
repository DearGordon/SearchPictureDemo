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

    var favoritedList: [ResultData] = []

    func getFavoritListFromCoreData(completion: (() -> Void)?) {

        CoreDataHelper.shared.loadResultData { (result) in
            switch result {
            case .success(let resultDatas):
                self.favoritedList = resultDatas
            case .failure(let error):
                print("Didn't get data from CoreData \(error.localizedDescription)")
            }
            completion?()
        }
    }

    func hasSameDataIndex(with data: ResultDataProtocol) -> Int? {

        for i in 0..<favoritedList.count {
            if data.pictureUrl == favoritedList[i].pictureUrl {
                return i
            }
        }
        return nil
    }

    func favoritedAction(with data: ResultDataProtocol) {

        guard let dataIndex = self.hasSameDataIndex(with: data) else {
            let resultData = self.castingToResultData(with: data)
            self.favoritedList.append(resultData)
            CoreDataHelper.shared.saveContext(completion: nil)
            return
        }

        let removed = self.favoritedList.remove(at: dataIndex)
        CoreDataHelper.shared.delete(removed)
    }

    private func castingToResultData(with data: ResultDataProtocol) -> ResultData {
        //if can't casting to ResultData, means data is from SearchResult
        if let data = data as? ResultData {
            print("pressed from Favorited Page ")
            return data
        } else {
            print("Pressed from Search Page")
            let moc = CoreDataHelper.shared.managedObjectContext()
            let newResultData = ResultData(context: moc)
            newResultData.title = data.pictureTitle
            newResultData.url = data.pictureUrl
            return newResultData
        }
    }

//    func favoritedAction(with data: ResultDataProtocol) {
//
//        var resultData: ResultData?
//        if let data = data as? ResultData {
//            resultData = data
//        } else {
//            let moc = CoreDataHelper.shared.managedObjectContext()
//            let newResultData = ResultData(context: moc)
//            newResultData.title = data.pictureTitle
//            newResultData.url = data.pictureUrl
//            resultData = newResultData
//        }
//
//        //if can't casting to ResultData, means data is from SearchResult
//        guard let dataIndex = self.hasSameDataIndex(with: data) else {
//            //新增
//            if let data = resultData {
//                self.favoritedList.append(data)
//            }
//            return
//        }
//        let removeData = self.favoritedList.remove(at: dataIndex)
//        CoreDataHelper.shared.delete(removeData)
//    }

}
