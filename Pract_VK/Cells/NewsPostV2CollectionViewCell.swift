//
//  NewsPostV2CollectionViewCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 29.03.2021.
//

import UIKit

class NewsPostV2CollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var avatarImg: RoundedView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    
    @IBOutlet weak var photosCollectionView: UICollectionView! {
        didSet {
            photosCollectionView.delegate = self
            photosCollectionView.dataSource = self
        }
    }
    
    var photos = [UIImage]()
    
    private let reusePhotoCellID = "NewsPhotoCell"
    
    func configure(name: String, date: String, postText: String, avatarImg: UIImage, photoImgs: [UIImage]) {
        nameLabel.text = name
        dateLabel.text = date
        postLabel.text = postText
        photos = photoImgs
        self.avatarImg.image = avatarImg
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photosCollectionView.register(UINib(nibName: "NewsPostPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reusePhotoCellID)
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        dateLabel.text = ""
        postLabel.text = ""
        avatarImg.image = nil
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photosCollectionView.bounds.width / CGFloat(photos.count >= 2 ? 2 : 1), height: photosCollectionView.bounds.height / CGFloat(photos.count >= 3 ? 2 : 1))
    }
    
}
