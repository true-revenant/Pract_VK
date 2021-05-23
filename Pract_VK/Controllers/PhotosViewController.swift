//
//  PhotosViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 13.03.2021.
//

import UIKit
import RealmSwift

class PhotosViewController: UIViewController {

    //var photos = [Photo]()
    var photos: Results<Photo>?
    
    private var currPhotoImageView = UIImageView()
    private var selectedPhotoIndex  = 0
    private var animationIsDone = true
    
    lazy private var photoImageTapRecognizer : UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        return recognizer
    }()
    
    lazy private var swipeLeftRecognizer : UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftHandle))
        recognizer.direction = .left
        return recognizer
    }()

    lazy private var swipeRightRecognizer : UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightHandle))
        recognizer.direction = .right
        return recognizer
    }()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            photos = try RealmManager.instance.loadFromRealm()
        }
        catch { print(error) }
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

extension PhotosViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell

        guard let ph = photos?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(ph)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        
        width -= insets
        width -= 10
        width /= 2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Фото \(indexPath.item + 1) выбрано!")
        
        selectedPhotoIndex = indexPath.item
        initPhotoImageView(index: selectedPhotoIndex)
        
        view.addGestureRecognizer(photoImageTapRecognizer)
        view.addGestureRecognizer(swipeLeftRecognizer)
        view.addGestureRecognizer(swipeRightRecognizer)
    }
    
    @IBAction func imageViewTapped() {
        print("Нажали на ImageVIew!")
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.currPhotoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.currPhotoImageView.alpha = 0
            self.collectionView.alpha = 1
        }, completion: {_ in
            self.currPhotoImageView.removeFromSuperview()
            self.view.removeGestureRecognizer(self.photoImageTapRecognizer)
            self.view.removeGestureRecognizer(self.swipeRightRecognizer)
            self.view.removeGestureRecognizer(self.swipeLeftRecognizer)
        })
    }
    
    private func initPhotoImageView(index: Int) {
        
        //currPhotoImageView = UIImageView(image: photos[index])
        currPhotoImageView.kf.setImage(with: URL(string: photos?[index].photoAddress ?? ""))
//        currPhotoImageView = UIImageView().kf.setImage(with: URL(string: photos[index].photoAddress))
        currPhotoImageView.backgroundColor = .white
        currPhotoImageView.frame = view.frame
        currPhotoImageView.contentMode = .scaleAspectFit
        currPhotoImageView.frame.origin = view.frame.origin
        view.addSubview(currPhotoImageView)
        
        currPhotoImageView.alpha = 0
        currPhotoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.currPhotoImageView.alpha = 1
            self.currPhotoImageView.transform = .identity
            self.collectionView.alpha = 0
        }, completion: nil)
        
        //collectionView.alpha = 0
    }
    
    @IBAction private func swipeLeftHandle() {

        if selectedPhotoIndex < photos!.count - 1 && animationIsDone {
            print("Листаем влево!")
            
            animationIsDone = false
//            let nextPhotoImageView = UIImageView(image: photos[selectedPhotoIndex + 1])
            let nextPhotoImageView = UIImageView()
            nextPhotoImageView.kf.setImage(with: URL(string: photos![selectedPhotoIndex + 1].photoAddress))
            nextPhotoImageView.backgroundColor = .white
            nextPhotoImageView.frame = view.frame
            nextPhotoImageView.contentMode = .scaleAspectFit
            nextPhotoImageView.frame.origin.x = view.frame.maxX
            view.addSubview(nextPhotoImageView)
            
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.currPhotoImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    nextPhotoImageView.frame.origin.x = 0
                    self.currPhotoImageView.alpha = 0.5
                })
            }, completion: {_ in
                
                self.currPhotoImageView.kf.setImage(with: URL(string: self.photos![self.selectedPhotoIndex + 1].photoAddress))
                
//                self.currPhotoImageView.image = self.photos[self.selectedPhotoIndex + 1]
                
                self.currPhotoImageView.alpha = 1
                self.currPhotoImageView.transform = .identity
                nextPhotoImageView.removeFromSuperview()
                self.selectedPhotoIndex += 1
                self.animationIsDone = true
            })
        }
        else { print("Вперед листать нельзя, на последнем элементе!") }
    }
    
    @IBAction private func swipeRightHandle() {
        if selectedPhotoIndex > 0 && animationIsDone {
            print("Листаем вправо!")
            animationIsDone = false
//            let prevPhotoImageView = UIImageView(image: photos[selectedPhotoIndex - 1])
            let prevPhotoImageView = UIImageView()
            prevPhotoImageView.kf.setImage(with: URL(string: photos![selectedPhotoIndex - 1].photoAddress))
            prevPhotoImageView.backgroundColor = .white
            prevPhotoImageView.frame = view.frame
            prevPhotoImageView.contentMode = .scaleAspectFit
            prevPhotoImageView.frame.origin.x = view.frame.origin.x - view.frame.maxX
            view.addSubview(prevPhotoImageView)
            
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.currPhotoImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    prevPhotoImageView.frame.origin.x = 0
                    self.currPhotoImageView.alpha = 0.5
                })
            }, completion: {_ in
//                self.currPhotoImageView.image = self.photos[self.selectedPhotoIndex - 1]
                self.currPhotoImageView.kf.setImage(with: URL(string: self.photos![self.selectedPhotoIndex - 1].photoAddress))
                
                self.currPhotoImageView.alpha = 1
                self.currPhotoImageView.transform = .identity
                prevPhotoImageView.removeFromSuperview()
                self.selectedPhotoIndex -= 1
                self.animationIsDone = true
            })
        }
        else { print("Назад листать нельзя, на первом элементе!") }
    }
}
