//
//  ResultViewController.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

protocol ResultDataProtocol {
    var title: String { get }
    var picture: UIImage { get }
}

protocol ResultViewModelProtocol: class {
    var resultArray: [ResultDataProtocol] { get }
    var numberOfItemsInSection: Int { get }
}

class ResultViewController: UIViewController {

    @IBOutlet weak var resultCollectionView: UICollectionView!

    var viewModel: ResultViewModelProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultCollectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResultCell")

        self.viewModel = ResultViewModel(withDelegate: self)
        self.resultCollectionView.delegate = self
        self.resultCollectionView.dataSource = self

        self.setCollectionViewLayout()

        ApiManager.shared.getData()
    }

    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()

        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let screenSize = UIScreen.main.bounds
        let width = (screenSize.size.width - 15)/2
        layout.itemSize = CGSize(width: width, height: width)
        self.resultCollectionView.collectionViewLayout = layout
    }
    
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfItemsInSection ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let viewModel = self.viewModel,
            let cell = self.resultCollectionView.dequeueReusableCell(withReuseIdentifier: ResultViewKey.resultCellId, for: indexPath) as? ResultCollectionViewCell else { return ResultCollectionViewCell() }

        cell.setResultCell(with: viewModel.resultArray[indexPath.row])

        return cell
    }

    

}

extension ResultViewController: ResultViewModelDelegate {

}
