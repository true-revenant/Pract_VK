//
//  NewsPostCollectionViewCellV3.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 14.08.2021.
//

import UIKit

class NewsPostCollectionViewCellV3: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var photos = [UIImage]()
    var avatarImage: UIImage!
    var authorName: String!
    var dateText: String!
    var messageText: String!
    
    private var headerCellID = "NewsPostHeaderCell"
    private var messageCellID = "NewsPostMessageCell"
    private var photosCellID = "NewsPostPhotosCell"
    private var bottomCellID = "NewsPostBottomCell"
    
    @IBOutlet weak var newspostCollectionView: UICollectionView! {
        didSet {
            newspostCollectionView.delegate = self
            newspostCollectionView.dataSource = self
        }
    }
    
    func configure(name: String, date: String, postText: String, avatarImg: UIImage, photoImgs: [UIImage]) {
        authorName = name
        dateText = date
        messageText = postText
        photos = photoImgs
        avatarImage = avatarImg
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newspostCollectionView.register(UINib(nibName: "NewsPostHeaderCell", bundle: nil), forCellWithReuseIdentifier: headerCellID)
        
        newspostCollectionView.register(UINib(nibName: "NewsPostMessageCell", bundle: nil), forCellWithReuseIdentifier: messageCellID)
        
        newspostCollectionView.register(UINib(nibName: "NewsPostPhotosCell", bundle: nil), forCellWithReuseIdentifier: photosCellID)
        
        newspostCollectionView.register(UINib(nibName: "NewsPostBottomCell", bundle: nil), forCellWithReuseIdentifier: bottomCellID)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            case 0:
                let cell = newspostCollectionView.dequeueReusableCell(withReuseIdentifier: headerCellID, for: indexPath) as! NewsPostHeaderCell
                
                cell.configure(_authorNameText: authorName, _avatarImg: avatarImage, _dateText: dateText)
                
                return cell
            case 1:
                let cell = newspostCollectionView.dequeueReusableCell(withReuseIdentifier: messageCellID, for: indexPath) as! NewsPostMessageCell
                
                cell.configure(_messageText: messageText)
                
                return cell
            case 2:
                let cell = newspostCollectionView.dequeueReusableCell(withReuseIdentifier: photosCellID, for: indexPath) as! NewsPostPhotosCell
                
                cell.configure(photoImgs: photos)
                
                return cell
                
            case 3:
                let cell = newspostCollectionView.dequeueReusableCell(withReuseIdentifier: bottomCellID, for: indexPath) as! NewsPostBottomCell
                
                cell.configure(likesCount: 10)
                
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            case 0:
                return CGSize(width: newspostCollectionView.bounds.width, height: 100)
            case 1:
                return CGSize(width: newspostCollectionView.bounds.width, height: 100)
            case 2:
                var sectionHeight = 300
                if (photos.count == 0) {
                    sectionHeight = 0
                }
                else { sectionHeight = 300 }
                
                return CGSize(width: newspostCollectionView.bounds.width, height: CGFloat(sectionHeight))
            case 3:
                return CGSize(width: newspostCollectionView.bounds.width, height: 33
                )
            default:
                return CGSize()
        }
    }
}
