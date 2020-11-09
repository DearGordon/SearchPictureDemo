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
        if let url = data.pictureUrl {
            self.picture.downloaded(from: url)
        }
        self.label.text = data.pictureTitle
    }
}

let imageCache = NSCache<NSURL, UIImage>()
fileprivate extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        image = nil

        //若有圖片有cache就從cache拿，若無則下載，並用url當作cache的key進行儲存
        if let imageFromCache = imageCache.object(forKey: url as NSURL) {
            self.image = imageFromCache

        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                imageCache.setObject(image, forKey: url as NSURL)

                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()

        }
    }

    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
