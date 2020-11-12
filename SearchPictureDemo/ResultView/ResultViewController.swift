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

enum ResultViewControllerMode {
    case Searching(searchInfo: SearchInfo)
    case Favorited
}

typealias SearchInfo = (text: String, page: Int, perPage: Int)

class ResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var viewModel: ResultViewModelProtocol?
    var resultMode: ResultViewControllerMode = .Favorited {
        didSet {
            self.setViewModel(mode: resultMode)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewModel(mode: resultMode)
        self.setRefreshControl()
        self.setCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPhotosData()
    }

    func setViewModel(mode: ResultViewControllerMode) {
        switch mode {

        case .Searching(searchInfo: let searchInfo):
            self.viewModel = SearchResultViewModel(searchInfo: searchInfo)
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
    
    //TODO: 下拉重新打API更新
    //TODO: 滑到最底時，秀出下一頁
    //https://franksios.medium.com/ios-uitableview-%E5%88%86%E9%A0%81-%E6%BB%91%E8%87%B3%E5%88%97%E8%A1%A8%E6%9C%80%E5%BE%8C%E4%B8%80%E7%AD%86%E4%B8%8A%E6%8B%89%E8%BC%89%E5%85%A5%E6%9B%B4%E5%A4%9A%E8%B3%87%E6%96%99-loading-more-69ee25eae045
    //TODO: 與我的最愛共用此頁
    
    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doRefreshthing), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    @objc func doRefreshthing() {
        print("refreshing")
        self.collectionView.refreshControl?.endRefreshing()
    }

    private func loadPhotosData() {
        
        self.viewModel?.getPhotosData(completion: {
            //finish load data, ready for reload collection view
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
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
