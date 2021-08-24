//
//  GroupsViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 05.03.2021.
//

import UIKit
import RealmSwift

class GroupsViewController: UITableViewController, UISearchBarDelegate {

    private var groups: Results<Group>!
    private var token: NotificationToken?
    
    private var searchGroups: Results<Group>!
    private var isSearch = false
    private let reuseHeaderID = "GroupSearchHeader"
    
    private func initSearchGroups(_ str: String) throws -> Results<Group> {
        
        let realm = try Realm()
        
        let _searchGroups = realm.objects(Group.self).filter("name CONTAINS %@ OR name CONTAINS %@ OR name CONTAINS %@", str.lowercased(), str.uppercased(), str)
        
        return _searchGroups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VKNetworkManager.instance.getGroups {}
        
        do { groups = try RealmManager.instance.loadFromRealm() }
        catch { print(error.localizedDescription) }
        
        print("Groups initialized!")
        
        self.tableView.register(UINib(nibName: "GroupsTableViewSearchHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: self.reuseHeaderID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("GroupsViewController WILL APPEAR!")
        
        groupsChangeSubscribe(groups)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("GroupsViewController WILL DISAPPEAR!")
        token?.invalidate()
    }

    private func groupsChangeSubscribe(_ groups: Results<Group>) {
        token = groups.observe { [weak self] changes in
            
            guard let tV = self?.tableView else { return }
            
            switch changes {
                case .initial:
                    tV.reloadData()
                case .update(_, let deletions, let insertions, let updates):
                    tV.beginUpdates()
                    tV.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tV.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tV.reloadRows(at: updates.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tV.endUpdates()
                case .error(let error):
                    print(error)
            }
        }
    }
    
    @IBAction func SearchButton_Tapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SegueFromGroupsToSearch", sender: self)
    }
    
    // действие - возврат в контроллер с моими группами после добавления группы
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup", let source = segue.source as? GroupSearchViewController {
            
            do {
                try RealmManager.instance.addNewGroupToRealm(g: source.selectedGroup!)
            }
            catch { print(error) }
        }
    }
    
    // MARK: - TABLE VIEW DATA SOURCE

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!isSearch) { return groups.count }
        else { return searchGroups.count }
    }

    // MARK: - TABLE VIEW DELEGATES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (!isSearch) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell

            cell.configure(groups[indexPath.row])
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell

            cell.configure(searchGroups[indexPath.row])
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseHeaderID) as! GroupsTableViewSearchHeader
        
        print("Задали делегат для серч бара!")
        header.SearchBar.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if !isSearch {
                RealmManager.instance.removeFromRealm(obj: groups![indexPath.row])
            }
            else {
                RealmManager.instance.removeFromRealm(obj: searchGroups[indexPath.row])
            }
        }
    }
    
    // MARK: - SEARCH BAR DELEGATES
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearch = false
        groupsChangeSubscribe(groups)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = searchText.isEmpty ? false : true
        if isSearch {
            searchGroups = try? initSearchGroups(searchText)
            groupsChangeSubscribe(searchGroups)
        }
        else {
            groupsChangeSubscribe(groups)
            tableView.reloadData()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
