//
//  NewsPostPhotosCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 14.08.2021.
//

import UIKit

class NewsPostPhotosCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let reusePhotoCellID = "NewsPhotoCell"
    
    lazy var photos = [UIImage]()
    
    @IBOutlet weak var photosCollectionView: UICollectionView! {
        didSet {
            photosCollectionView.delegate = self
            photosCollectionView.dataSource = self
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photosCollectionView.register(UINib(nibName: "NewsPostPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reusePhotoCellID)
    }
    
    func configure(photoImgs: [UIImage]) {
        self.photos = photoImgs
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (photos.count < 4) { return photos.count }
        else { return 4 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: reusePhotoCellID, for: indexPath) as! NewsPostPhotoCollectionViewCell
        
        cell.img.image = photos[indexPath.item]
        
        if indexPath.item == 3 && indexPath.item < photos.count - 1 {
            let photo_rem = photos.count - (indexPath.item + 1)
            cell.counterLabel.alpha = 1
            cell.counterLabel.text = "+\(photo_rem)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: photosCollectionView.bounds.width / CGFloat(photos.count >= 2 ? 2 : 1), height: photosCollectionView.bounds.height / CGFloat(photos.count >= 3 ? 2 : 1))
    }
}
