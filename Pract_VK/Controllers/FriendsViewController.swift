//
//  FriendsViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 20.03.2021.
//

import UIKit

class FriendsViewController: UIViewController {

    // MARK: - FIELDS

    var friendsList: [Friend]?
    var selectedFriend: Friend!
    var friendsBySections = [[Friend]]()
    
    let reuseHeaderID = "FriendsHeader"
    
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
    
    // MARK: - PRIVATE METHODS
    
    // Инициализируем массив уникальных первых букв фамилий всех друзей в SearchFriendControl
    private func initLetterArray() {
        guard let fListArr = friendsList else { return }
        
        let firstLetters = fListArr.map() {
            return $0.firstName.uppercased().first!
        }
        
        letterSearchControl.letters.removeAll()
        
        for l in firstLetters {
            if !letterSearchControl.letters.contains(l) {
                letterSearchControl.letters.append(l)
            }
        }
        letterSearchControl.letters.sort()
        
        print(letterSearchControl.letters)
    }
    
    private func initFriendsBySections() {
        
        for letter in letterSearchControl.letters {
            friendsBySections.append(getFriendsByFirstLastNameLetter(firstChar: letter))
        }
    }
    
    private func getFriendsByFirstLastNameLetter(firstChar: Character) -> [Friend] {
        
        var currList = [Friend]()
        
        guard let fList = friendsList else { return currList }
        
        for friend in fList {
            if (friend.lastName.first == firstChar) {
                currList.append(friend)
            }
        }
        
        return currList
    }
    
    // MARK: - OVERRIDEN METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FriendsTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: reuseHeaderID)
        
        friendsList = VKNetworkManager.instance.friends
        
        initLetterArray()
        letterSearchControl.initControl()
        initFriendsBySections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("FriendsViewController WILL APPEAR!")
        super.viewWillAppear(animated)
        //friendsSectionsChangeSubscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("FriendsViewController WILL DISAPPEAR!")
        super.viewDidDisappear(animated)
//        for i in 0...tokens.count - 1 {
//            tokens[i].invalidate()
//        }
//        tokens.removeAll()
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
        
        VKNetworkManager.instance.getAllPhotos(userId: selectedFriend.id, { [weak self] in
            self?.performSegue(withIdentifier: "SegueFriendsToPhotos", sender: self)
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            print("TABLE VIEW EDITING STYLE CALLED!!")
            
            if (friendsBySections[indexPath.section].count == 1) {
                
                friendsBySections[indexPath.section].remove(at: indexPath.row)
                friendsBySections.remove(at: indexPath.section)
                
                initLetterArray()
                letterSearchControl.initControl()
            }
            else {
                friendsBySections[indexPath.section].remove(at: indexPath.row)
            }
            
            tableView.reloadData()
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
