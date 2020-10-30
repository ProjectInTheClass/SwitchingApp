//
//  filterTagsViewController.swift
//  TagPractice
//
//  Created by JNGSJN on 2020/10/29.
//

import UIKit


var selectedTags: Array<String> = []

class FilterDetailViewController: UIViewController {
    
    let tags = accounts[0].accountTags
    
    @IBOutlet weak var filterDetailTableView: UITableView!
//    @IBAction func onPerformSegue(_ sender: Any) {
//        self.performSegue(withIdentifier: "FeedVC", sender: self)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterDetailTableView.delegate = self
        self.navigationController?.isNavigationBarHidden = false
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? FeedViewController {
//            vc.filterTags = selectedTags
//        }
//    }
}

extension FilterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tags.count == 0 {
            return 1
        } else {
            return tags.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableViewCell", for: indexPath) as! FilterDetailTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if tags.count == 0 {
            cell.textLabel?.text = "등록된 태그가 없습니다"
        } else {
            cell.textLabel?.text = tags[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            }
        }
        selectedTags.append(tags[indexPath.row])
        print(selectedTags)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
            }
        }
        if let index = selectedTags.firstIndex(of: tags[indexPath.row]) {
            selectedTags.remove(at: index)
        }
        print(selectedTags)
    }
}
