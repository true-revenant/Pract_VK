//
//  NewsV2ViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 29.03.2021.
//

import UIKit

class NewsV2ViewController: UIViewController {

    private var posts = [NewsPost]()
    private let reuseCellID = "NewsCell"
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "NewsPostV2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseCellID)
        initNewsPosts()
    }
    
    private func initNewsPosts() {
        let post1_photos : [UIImage] = [
            UIImage(named: "friend_81")!,
            UIImage(named: "friend_73")!,
            UIImage(named: "friend_11")!,
            UIImage(named: "friend_21")!,
            UIImage(named: "friend_22")!,
            UIImage(named: "friend_23")!
        ]
        
        let post2_photos : [UIImage] = [
            UIImage(named: "friend_91")!,
            UIImage(named: "friend_13")!
        ]
        
        let post3_photos : [UIImage] = [
            UIImage(named: "friend_81")!
        ]
        
        let post6_photos : [UIImage] = [
            UIImage(named: "friend_41")!,
            UIImage(named: "friend_42")!,
            UIImage(named: "friend_43")!,
        ]
        
        posts = [
            
            NewsPost(avatarImage: UIImage(named: "friend_8")!, lastName: "Сатриани", firstName: "Джо", date: "28.03.2021", postText: "Всем привет! Я зарегался в ВК!", photos: post1_photos),
            NewsPost(avatarImage: UIImage(named: "friend_9")!, lastName: "Вай", firstName: "Стив", date: "28.03.2021", postText: "Всем привет! И я зарегался в ВК!", photos: post2_photos),
            NewsPost(avatarImage: UIImage(named: "friend_4")!, lastName: "Абази", firstName: "Тосин", date: "29.03.2021", postText: "Всем привет! Вчера сочинил трек в какой-то сумасшедшей размерности.. Как его играть теперь без понятия)) Очередной челлендж, прорвемся!)", photos: post3_photos),
            NewsPost(avatarImage: UIImage(named: "friend_1")!, lastName: "Джонстон", firstName: "Ник", date: "29.03.2021", postText: "Концерт был огонь! Увидимся через пару месяцев!"),
            NewsPost(avatarImage: UIImage(named: "friend_1")!, lastName: "Джонстон", firstName: "Ник", date: "30.03.2021", postText: "Погода кайф!", photos: post6_photos),
            NewsPost(avatarImage: UIImage(named: "friend_9")!, lastName: "Вай", firstName: "Стив", date: "30.03.2021", postText: "Зацените мою новую гитару, она шикарна!")
        ]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsV2ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellID, for: indexPath) as! NewsPostV2CollectionViewCell
        
        cell.configure(name: "\(posts[indexPath.item].firstName) \(posts[indexPath.item].lastName)", date: posts[indexPath.item].date, postText: posts[indexPath.item].postText, avatarImg: posts[indexPath.item].avatarImage, photoImgs: posts[indexPath.item].photos)
    
        print(indexPath.item)
        print(posts[indexPath.item].postText)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellHeight = CGFloat(580)
        if posts[indexPath.item].photos.count == 0 {
            //cellHeight -= posts[indexPath.item].postImage.size.height
            cellHeight -= 350
        }
        
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
