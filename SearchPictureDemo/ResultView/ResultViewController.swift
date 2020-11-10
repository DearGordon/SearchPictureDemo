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
