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
    func getPhotosData(isTurnPage: Bool, completion: @escaping (() -> Void))
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
            self.setModel(to: resultMode)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setModel(to: resultMode)
        self.setCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPhotosData()
    }

    private func setModel(to mode: ResultMode) {
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

    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(freshthAction), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    @objc func freshthAction() {
        self.loadPhotosData()
    }

    private func loadPhotosData() {
        self.viewModel?.getPhotosData(isTurnPage: false, completion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        })
    }

    private func loadingMoreData() {
        self.viewModel?.getPhotosData(isTurnPage: true, completion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let number = self.viewModel?.numberOfItemsInSection ?? 0
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


extension ResultViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > self.collectionView.frame.height else { return }

        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10 {

            switch self.resultMode {
            case .Searching(_):
                self.loadingMoreData()
            case .Favorited:
                return
            }

        }
    }
}
