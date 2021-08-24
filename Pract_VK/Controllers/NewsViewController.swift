//
//  NewsViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 27.03.2021.
//

import UIKit

class NewsViewController: UIViewController {

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
        collectionView.register(UINib(nibName: "NewsPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseCellID)
        initNewsPosts()
        VKNetworkManager.instance.getNewsfeed()
    }
    
    private func initNewsPosts() {
        posts = [
            NewsPost(avatarImage: UIImage(named: "friend_8")!, lastName: "Сатриани", firstName: "Джо", date: "28.03.2021", postText: "Всем привет! Я зарегался в ВК!", postImage: UIImage(named: "news_1")!),
            NewsPost(avatarImage: UIImage(named: "friend_9")!, lastName: "Вай", firstName: "Стив", date: "28.03.2021", postText: "Всем привет! И я зарегался в ВК!", postImage: UIImage(named: "news_2")!),
            NewsPost(avatarImage: UIImage(named: "friend_4")!, lastName: "Абази", firstName: "Тосин", date: "29.03.2021", postText: "Всем привет! Вчера сочинил трек в какой-то сумасшедшей размерности.. Как его играть теперь без понятия)) Очередной челлендж, прорвемся!)", postImage: UIImage.init()),
            NewsPost(avatarImage: UIImage(named: "friend_4")!, lastName: "Абази", firstName: "Тосин", date: "29.03.2021", postText: "Всем привет! Вчера сочинил трек в какой-то сумасшедшей размерности.. Как его играть теперь без понятия)) Очередной челлендж, прорвемся!)", postImage: UIImage.init()),
            NewsPost(avatarImage: UIImage(named: "friend_4")!, lastName: "Абази", firstName: "Тосин", date: "29.03.2021", postText: "Всем привет! Вчера сочинил трек в какой-то сумасшедшей размерности.. Как его играть теперь без понятия)) Очередной челлендж, прорвемся!)", postImage: UIImage.init()),
            NewsPost(avatarImage: UIImage(named: "friend_4")!, lastName: "Абази", firstName: "Тосин", date: "29.03.2021", postText: "Всем привет! Вчера сочинил трек в какой-то сумасшедшей размерности.. Как его играть теперь без понятия)) Очередной челлендж, прорвемся!)", postImage: UIImage.init())
            
//            Вчера сочинил трек в какой-то сумасшедшей размерности.. Как его играть теперь без понятия)) Очередной челлендж, прорвемся!)
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

extension NewsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellID, for: indexPath) as! NewsPostCollectionViewCell
        
        cell.configure(name: "\(posts[indexPath.item].firstName) \(posts[indexPath.item].lastName)", date: posts[indexPath.item].date, postText: posts[indexPath.item].postText, postImg: posts[indexPath.item].postImage, avatarImg: posts[indexPath.item].avatarImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellHeight = CGFloat(624)
        if posts[indexPath.item].postImage == UIImage.init() {
            //cellHeight -= posts[indexPath.item].postImage.size.height
            cellHeight -= 350
        }
        
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


