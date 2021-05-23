//
//  GroupSearchViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 05.04.2021.
//

import UIKit

class GroupSearchViewController: UIViewController {

    private var searchGroups = [Group]()
    private var isSearch = false
    
    var selectedGroup: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var customSearchBar: CustomSearchBar!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBAction func searchTextChange(_ sender: CustomSearchBar) {
        print("Текст - \(sender.searchText)")
        isSearch = sender.searchText.isEmpty ? false : true
        if isSearch {
            VKNetworkManager.instance.getSearchGroups(sender.searchText, {
                self.searchGroups = VKNetworkManager.instance.searchGroups
                self.tableView.reloadData()
            })
        }
        else { searchGroups.removeAll() }
        tableView.reloadData()
    }
}

extension GroupSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!isSearch) { return 0 }
        else { return searchGroups.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isSearch { return UITableViewCell() }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
                
            cell.configure(searchGroups[indexPath.row])
    
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearch {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedGroup = searchGroups[indexPath.row]
            performSegue(withIdentifier: "addGroup", sender: self)
        }
    }
}
