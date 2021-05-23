//
//  FriendsViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 20.03.2021.
//

import UIKit
import RealmSwift

class FriendsViewController: UIViewController {

    // MARK: - FIELDS

    let reuseHeaderID = "FriendsHeader"
    
    var tokens = [NotificationToken]()
    var token: NotificationToken?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.dataSource = self;
            tableView.delegate = self;
        }
    }
    
    @IBOutlet var letterSearchControl: FriendSearchControl!
    
    @IBAction func scrollViewToItem(sender: FriendSearchControl) {
        print("letter selected - \(sender.selectedLetter)!")
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: letterSearchControl.letters.firstIndex() { $0 == Character(sender.selectedLetter) }! ), at: .bottom, animated: true)
    }
    
    var friendsList: Results<Friend>?
    var selectedFriend: Friend!
    var friendsBySections = [Results<Friend>]()
    
    // MARK: - PRIVATE METHODS
    
    // Инициализируем массив уникальных первых букв фамилий всех друзей в SearchFriendControl
    private func initLetterArray() {
        guard let fListArr = friendsList else { return }
        
        let firstLetters = fListArr.map() { return $0.firstName.uppercased().first! }
        
        letterSearchControl.letters.removeAll()
        for l in firstLetters {
            if !letterSearchControl.letters.contains(l) {
                letterSearchControl.letters.append(l)
            }
        }
        letterSearchControl.letters.sort()
        
        print(letterSearchControl.letters)
    }
    
    private func friendsSectionsChangeSubscribe() {

        for i in 0...friendsBySections.count - 1 {
            
            let sectToken = friendsBySections[i].observe { [weak self] changes in
                
                guard let tV = self?.tableView else { return }
                
                switch changes {
                    case .initial:
                        tV.reloadData()
                    case .update(let results, let deletions, let insertions, let updates):
                        tV.beginUpdates()
                        tV.insertRows(at: insertions.map({ IndexPath(item: $0, section: i) }), with: .automatic)
                        // Удаляем секцию если из нее была удалена последняя строка
                        if results.isEmpty {
                            tV.deleteSections(IndexSet([i]), with: .automatic)
                        }
                        else {
                            tV.deleteRows(at: deletions.map({ IndexPath(item: $0, section: i) }), with: .automatic)
                        }
                        tV.reloadRows(at: updates.map({ IndexPath(item: $0, section: i) }), with: .automatic)
                        tV.endUpdates()
                    case .error(let error):
                        print(error)
                }
            }
            tokens.append(sectToken)
        }
    }
    
    private func initFriendsBySections() {
        do {
            let realm = try Realm()
            for letter in letterSearchControl.letters {
                
                let friendsOneSection = realm.objects(Friend.self).filter("firstName BEGINSWITH %@", String(letter))
                
                friendsBySections.append(friendsOneSection)
            }
        }
        catch { print(error) }
    }
    
    // MARK: - OVERRIDEN METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FriendsTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: reuseHeaderID)

        do {
            friendsList = try RealmManager.instance.loadFromRealm()
            initLetterArray()
            letterSearchControl.initControl()
            initFriendsBySections()
        }
        catch { print(error) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("FriendsViewController WILL APPEAR!")
        super.viewWillAppear(animated)
        friendsSectionsChangeSubscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("FriendsViewController WILL DISAPPEAR!")
        super.viewDidDisappear(animated)
        for i in 0...tokens.count - 1 {
            tokens[i].invalidate()
        }
        tokens.removeAll()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        // MARK: - ЗАДАНИЕ 8.2
//        if segue.identifier == "SegueFriendsToPhotos", let destination = segue.destination as? PhotosViewController {
//            destination.title = "Фотографии - \(selectedFriend.lastName) \(selectedFriend.firstName)"
//            VKNetworkManager.instance.getAllPhotos(userId: "\(selectedFriend.id)", {
//                destination.photos = VKNetworkManager.instance.photos
//                destination.collectionView.reloadData()
//            })
//        }
        
        // MARK: - ЗАДАНИЕ 8.3
        if segue.identifier == "SegueFriendsToPhotos", let destination = segue.destination as? PhotosViewInteractiveAnimationController {
            destination.title = "Фотографии - \(selectedFriend.lastName) \(selectedFriend.firstName)"
        }
    }
}

extension FriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("NUMBER OF SECTIONS CALLED!!")
        return letterSearchControl.letters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView numberOfRowsInSection CALLED!!")
        if friendsBySections[section].isEmpty { return 0 }
        else { return friendsBySections[section].count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("tableView cellForRowAt CALLED!!")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell

        cell.configure(friendsBySections[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedFriend = friendsBySections[indexPath.section][indexPath.row]
        
        RealmManager.instance.currentPhotoOwnerID = selectedFriend.id
        VKNetworkManager.instance.getAllPhotos(userId: selectedFriend.id, {})
        
        self.performSegue(withIdentifier: "SegueFriendsToPhotos", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            print("TABLE VIEW EDITING STYLE CALLED!!")
            
            if (friendsBySections[indexPath.section].count == 1) {
                //удаляем из общего списка по полю ID
                
                RealmManager.instance.removeFromRealm(obj: friendsBySections[indexPath.section][indexPath.row])
                
                // удаляем текущую секцию
                friendsBySections.remove(at: indexPath.section)
                initLetterArray()
                
                letterSearchControl.initControl()
            }
            else {
                RealmManager.instance.removeFromRealm(obj: friendsBySections[indexPath.section][indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if !friendsBySections[section].isEmpty {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseHeaderID) as! FriendsTableViewHeader
            
            header.configure(text: String(letterSearchControl.letters[section]))
            
            return header
        }
        else { return nil }
    }
}
