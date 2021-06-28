//
//  PhotosViewInteractiveAnimationController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 12.04.2021.
//

import UIKit

class PhotosViewInteractiveAnimationController: UIViewController {
    
    var photos: [Photo]?

    private var swipeDirection : SwipeDirection = .none
    private var currPhotoImageView = UIImageView()
    private var prevPhotoImageView = UIImageView()
    private var nextPhotoImageView = UIImageView()
    private var selectedPhotoIndex = 0
    
    lazy private var photoImageSwipeDownRecognizer : UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(CloseOnSwipeDown(recognizer:)))
        recognizer.direction = .down
        return recognizer
    }()
    
    private var startLocationX : CGFloat = 0
    private var anim : UIViewPropertyAnimator!
    private var progress : CGFloat = 0
    
    lazy private var photoImageTapRecognizer : UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        return recognizer
    }()
    
    lazy private var photoPanRecognizer : UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(recognizer:)))
        return recognizer
    }()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    deinit {
        print("PhotosViewController DEINIT!")
        //token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photos = VKNetworkManager.instance.photos
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("FriendsViewController WILL APPEAR!")
        super.viewWillAppear(animated)
        //photosSubscribe()
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
        })
    }
      
    private func initPhotoImageView(index: Int) {
        
        //currPhotoImageView = UIImageView(image: photos[index])
        currPhotoImageView.kf.setImage(with: URL(string: photos![index].photoAddress))
        currPhotoImageView.backgroundColor = .white
        currPhotoImageView.frame = view.frame
        currPhotoImageView.contentMode = .scaleAspectFit
        currPhotoImageView.frame.origin = view.frame.origin
        view.addSubview(currPhotoImageView)
        
    }
    
    private func setCurrPhotoImageView() {
        currPhotoImageView.kf.setImage(with: URL(string: photos![selectedPhotoIndex].photoAddress))
        currPhotoImageView.transform = .identity
        currPhotoImageView.alpha = 1
    }
    
    private func currImageFirstAppearanceAnimation() {
        currPhotoImageView.alpha = 0
        currPhotoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.currPhotoImageView.alpha = 1
            self.currPhotoImageView.transform = .identity
            self.collectionView.alpha = 0
        }, completion: {_ in
            self.view.addGestureRecognizer(self.photoImageTapRecognizer)
            self.view.addGestureRecognizer(self.photoPanRecognizer)
            self.view.addGestureRecognizer(self.photoImageSwipeDownRecognizer)
            self.photoPanRecognizer.delegate = self
        })
    }
    
    private func initNextPhotoImageView() -> UIImageView {
//        let nextPhotoImageView = UIImageView(image: photos[selectedPhotoIndex + 1])
        
        let _nextPhotoImageView = UIImageView()
        _nextPhotoImageView.kf.setImage(with: URL(string: photos![selectedPhotoIndex + 1].photoAddress))
        _nextPhotoImageView.backgroundColor = .white
        _nextPhotoImageView.frame = view.frame
        _nextPhotoImageView.contentMode = .scaleAspectFit
        //nextPhotoImageView.frame.origin.x = view.frame.maxX
        //view.addSubview(nextPhotoImageView)
        
        // состояние перед анимацией
        _nextPhotoImageView.alpha = 0.5
        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let translate = CGAffineTransform(translationX: view.frame.maxX, y: 0)
        _nextPhotoImageView.transform = scale.concatenating(translate)
        view.addSubview(_nextPhotoImageView)
        
        return _nextPhotoImageView
    }
    
    private func initPrevPhotoImageView() -> UIImageView {
//        let prevPhotoImageView = UIImageView(image: photos[selectedPhotoIndex - 1])
        let _prevPhotoImageView = UIImageView()
        _prevPhotoImageView.kf
            .setImage(with: URL(string: photos![selectedPhotoIndex - 1].photoAddress))
        _prevPhotoImageView.backgroundColor = .white
        _prevPhotoImageView.frame = view.frame
        _prevPhotoImageView.contentMode = .scaleAspectFit
        //prevPhotoImageView.frame.origin.x = view.frame.origin.x - view.frame.maxX
        _prevPhotoImageView.frame.origin.x = view.frame.origin.x
        
        // состояние перед анимацией
        _prevPhotoImageView.alpha = 0.5
        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let translate = CGAffineTransform(translationX: -view.frame.maxX, y: 0)
        _prevPhotoImageView.transform = scale.concatenating(translate)
        view.addSubview(_prevPhotoImageView)
        
        return _prevPhotoImageView
    }

    @objc private func CloseOnSwipeDown(recognizer: UISwipeGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.currPhotoImageView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.currPhotoImageView.alpha = 0.3
            self.collectionView.alpha = 1
        }, completion: {_ in
            self.currPhotoImageView.removeFromSuperview()
            self.view.removeGestureRecognizer(self.photoImageSwipeDownRecognizer)
            self.view.removeGestureRecognizer(self.photoImageTapRecognizer)
        })
    }
    
    @objc private func onPan(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
            case .began:
                print("Начали вести пальцем по экрану!")
                
                swipeDirection = recognizer.velocity(in: self.view).x > 0 ? .right : .left
                
                switch swipeDirection {
                case .left:
                    print("LEFT")
                    anim = getSwipeLeftAnimator()
                case .right:
                    print("RIGHT")
                    anim = getSwipeRightAnimator()
                default:
                    print("NONE")
                }
                
                progress = 0
                anim.pauseAnimation()
                startLocationX = recognizer.translation(in: self.view).x
                
            case .changed:
                
                if swipeDirection == .left {
                    print("Двигаем влево!")
                    progress = (startLocationX - recognizer.translation(in: self.view).x) / UIScreen.main.bounds.width
                }
                else if swipeDirection == .right {
                    print("Двигаем вправо!")
                    progress = (recognizer.translation(in: self.view).x - startLocationX) / UIScreen.main.bounds.width
                }
                
                anim.fractionComplete = progress
                print(progress)
                
            case .ended:
                print("Закончили вести пальцем по экрану!")
                if progress < 0.5 {
                    cancelInteractiveAnimation()
                    print("Не закончили свайпать, отменяем анимацию!")
                    if self.swipeDirection == .left && selectedPhotoIndex < photos!.count - 1 {
                        self.nextPhotoImageView.removeFromSuperview()
                    }
                    if self.swipeDirection == .right && selectedPhotoIndex > 0 {
                        self.prevPhotoImageView.removeFromSuperview()
                    }
                }
                else {
                    if self.swipeDirection == .left && selectedPhotoIndex < photos!.count - 1 || self.swipeDirection == .right && selectedPhotoIndex > 0 {
                        anim.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    }
                    else { self.cancelInteractiveAnimation() }
                    anim.addCompletion({_ in
                        if self.swipeDirection == .left && self.selectedPhotoIndex < self.photos!.count - 1 {

                                self.nextPhotoImageView.removeFromSuperview()
                                
                                self.selectedPhotoIndex += 1
                                self.setCurrPhotoImageView()
                        }
                        else if self.swipeDirection == .right && self.selectedPhotoIndex > 0 {

                                self.prevPhotoImageView.removeFromSuperview()
                                self.selectedPhotoIndex -= 1
                                self.setCurrPhotoImageView()
                        }
                    })
                }
            default: return
        }
    }
    
    private func getSwipeRightAnimator() -> UIViewPropertyAnimator {

        if selectedPhotoIndex > 0 {
            
            prevPhotoImageView = self.initPrevPhotoImageView()
            
            let anim = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                self.prevPhotoImageView.transform = .identity
                self.prevPhotoImageView.alpha = 1
                self.currPhotoImageView.alpha = 0.5
                let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
                let translate = CGAffineTransform(translationX: self.currPhotoImageView.frame.width, y: 0)
                self.currPhotoImageView.transform = scale.concatenating(translate)
            })
            return anim
        }
        else {
            let anim = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                self.currPhotoImageView.transform = CGAffineTransform(translationX: 50, y: 0)
            })
            return anim
        }
    }
    
    private func getSwipeLeftAnimator() -> UIViewPropertyAnimator {

        if selectedPhotoIndex < photos!.count - 1 {
            
            nextPhotoImageView = self.initNextPhotoImageView()

            let anim = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                self.nextPhotoImageView.transform = .identity
                self.nextPhotoImageView.alpha = 1
                self.currPhotoImageView.alpha = 0.5
                let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
                let translate = CGAffineTransform(translationX: -self.currPhotoImageView.frame.width, y: 0)
                self.currPhotoImageView.transform = scale.concatenating(translate)
            })
            return anim
        }
        else {
            let anim = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                self.currPhotoImageView.transform = CGAffineTransform(translationX: -50, y: 0)
            })
            return anim
        }
    }
    
    private func cancelInteractiveAnimation() {
        anim.stopAnimation(true)
        //anim.finishAnimation(at: .start)
        
        anim.addAnimations {
            self.currPhotoImageView.transform = .identity
            self.currPhotoImageView.alpha = 1
        }
        anim.startAnimation()
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

extension PhotosViewInteractiveAnimationController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.configure(photos![indexPath.item])
        
        //cell.photoImage.image = photos[indexPath.item]
        //cell.appearAnimation()
        //cell.appearAnimationLayer()
        
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
        currImageFirstAppearanceAnimation()
    }
}

enum SwipeDirection {
    case left, right, none
}
