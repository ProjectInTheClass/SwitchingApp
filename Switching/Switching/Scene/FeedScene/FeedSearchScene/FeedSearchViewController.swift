//
//  FeedSearchViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/11/07.
//

import UIKit

class FeedSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        if let cancelButton : UIButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "unwindToFeedVC2", sender: self)
    }
}

extension FeedSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedSearchCell", for: indexPath) as! FeedSearchTableViewCell
        return cell
    }
    
    
}
