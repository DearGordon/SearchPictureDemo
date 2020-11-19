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
    func getPhotosData(completion: @escaping (() -> Void))
}

enum ResultMode {
    case Searching(searchInfo: SearchInfo)
    case Favorited
}

typealias SearchInfo = (text: String, page: Int, perPage: Int)

class ResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var viewModel: ResultViewModelProtocol?

    /// 設定Result結果
    var resultMode: ResultMode = .Favorited {
        didSet {
            self.setModel(resultMode)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setModel(resultMode)
        self.setCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewWillAppear")
        self.loadPhotosData()
    }

    private func setModel(_ mode: ResultMode) {

        switch mode {
        case .Searching(searchInfo: let searchInfo):
            self.viewModel = SearchResultViewModel(searchInfo: searchInfo)
            self.setRefreshControl()

        case .Favorited:
            self.viewModel = FavoritedViewModel()
        }
    }

    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setCollectionViewLayout()
        self.collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResultCell")
    }

    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()

        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let screenSize = UIScreen.main.bounds
        let width = (screenSize.size.width - 15)/2
        layout.itemSize = CGSize(width: width, height: width)
        self.collectionView.collectionViewLayout = layout
    }

    //TODO: 滑到最底時，秀出下一頁
    //https://franksios.medium.com/ios-uitableview-%E5%88%86%E9%A0%81-%E6%BB%91%E8%87%B3%E5%88%97%E8%A1%A8%E6%9C%80%E5%BE%8C%E4%B8%80%E7%AD%86%E4%B8%8A%E6%8B%89%E8%BC%89%E5%85%A5%E6%9B%B4%E5%A4%9A%E8%B3%87%E6%96%99-loading-more-69ee25eae045
    
    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doRefreshthing), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    @objc func doRefreshthing() {
        self.loadPhotosData()
    }

    private func loadPhotosData() {
        self.viewModel?.getPhotosData(completion: {
            DispatchQueue.main.async {
                print("拿到資料開始重新整理")
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        })
    }
    
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let number = self.viewModel?.numberOfItemsInSection ?? 0
        print("我要顯示\(number)筆資料")
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let viewModel = self.viewModel,
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ResultViewKey.cellId, for: indexPath) as? ResultCollectionViewCell else { return ResultCollectionViewCell() }

        let resultData = viewModel.resultArray[indexPath.row]
        let cellViewModel = ResultCollectionViewCellViewModel(resultData: resultData)
        cell.setResultCell(with: cellViewModel)

        return cell
    }

}
