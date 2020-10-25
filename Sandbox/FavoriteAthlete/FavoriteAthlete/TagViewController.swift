//
//  TagViewController.swift
//  FavoriteAthlete
//
//  Created by JNGSJN on 2020/10/18.
//

import UIKit

class TagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var selectTableView: UITableView!
//    @IBAction func deselectAllButton( _sender: UIBarButtonItem){
//        for i in 0..<tags.count {
//        }
//        selectTableView.reloadData()
//    }
    var cellId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        selectTableView.dataSource = self
        selectTableView.delegate = self
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        selectTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        if !tags[indexPath.row].isSelected {
//            cell.accessoryType = .none
//            } else if tags[indexPath.row].isSelected {
//                cell.accessoryType = .checkmark
//            }
        cell.textLabel?.text = tags[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex: [IndexPath] = tableView.indexPathsForSelectedRows ?? []
        print(selectedIndex) //[[0,2], [0,5]] section 0의 2번째 row~
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                }
            }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                }
        }
    }
}
