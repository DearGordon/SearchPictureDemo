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

//        self.setFakeData()
//        return

        let datas = UserDefaults.standard.read(key: .favorited) as! Data
        do {
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(datas)

            guard let data = object as? [FakeData] else {
                print("FakeData casting fail")
                return
            }

            self.dataArray = data
            completion()
        } catch {
            print("unarchive fail \(error.localizedDescription)")
        }
    }

    func setFakeData() {
        var fakeDataArray: [FakeData] = []

        for _ in 0...4 {
            fakeDataArray.append(FakeData())
        }



        do {
            let data: NSData = NSData(bytes: fakeDataArray, length: fakeDataArray.count)
            let encodeObject = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)

            UserDefaults.standard.save(key: .favorited, value: encodeObject)
            print("完成")

        } catch {
            print("轉Data失敗 \(error.localizedDescription)")
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
