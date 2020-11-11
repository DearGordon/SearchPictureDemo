//
//  ResultViewController.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol ResultDataProtocol {
    var pictureTitle: String { get }
    var pictureUrl: String? { get }
}

protocol ResultViewModelProtocol: class {
    var resultArray: [ResultDataProtocol] { get }
    var numberOfItemsInSection: Int { get }
    func getData(text: String, perPage: Int, page: Int, completion: @escaping (() -> Void))
}

typealias SearchInfo = (text: String, page: Int, perPage: Int)

class ResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: ResultViewModelProtocol?
    var searchInfo: SearchInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Result didload")
        self.collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResultCell")

        self.viewModel = ResultViewModel(withDelegate: self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.setCollectionViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    //TODO: 下拉重新打API更新
    //TODO: 滑到最底時，秀出下一頁
    //https://franksios.medium.com/ios-uitableview-%E5%88%86%E9%A0%81-%E6%BB%91%E8%87%B3%E5%88%97%E8%A1%A8%E6%9C%80%E5%BE%8C%E4%B8%80%E7%AD%86%E4%B8%8A%E6%8B%89%E8%BC%89%E5%85%A5%E6%9B%B4%E5%A4%9A%E8%B3%87%E6%96%99-loading-more-69ee25eae045
    //TODO: 與我的最愛共用此頁
    //TODO: getdata只跟data拿dataArray的資料
    func getData() {
        guard let searchInfo = self.searchInfo else { return }
        self.viewModel?.getData(text: searchInfo.text, perPage: searchInfo.perPage, page: searchInfo.page, completion: {

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }

    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()

        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let screenSize = UIScreen.main.bounds
        let width = (screenSize.size.width - 15)/2
        layout.itemSize = CGSize(width: width, height: width)
        self.collectionView.collectionViewLayout = layout
    }
    
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfItemsInSection ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let viewModel = self.viewModel,
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ResultViewKey.cellId, for: indexPath) as? ResultCollectionViewCell else { return ResultCollectionViewCell() }

        cell.setResultCell(with: viewModel.resultArray[indexPath.row])

        return cell
    }

    

}

extension ResultViewController: ResultViewModelDelegate {
//    func reloadView() {
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//    }
}
