//
//  ResultCollectionViewCell.swift
//  SearchPictureDemo
//
//  Created by Gordon Feng on 26/10/20.
//  Copyright © 2020 GordonFeng. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!

    func setResultCell(with data: ResultDataProtocol) {
        self.picture.image = data.picture
        self.label.text = data.title
    }
}
