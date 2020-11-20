//
//  FeedFilterlViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/30.
//

import UIKit

class FeedFilterViewController: UIViewController {
    
    var tags: Array<String> = SharedData.instance.getTagListOfSelectedCharacter()
    static var filteredTags: Array<String> = [] //임시데이터
    
    @IBOutlet weak var FeedFilterTableView: UITableView!
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToFeedVC", sender: sender)
        NotificationCenter.default.post(name: Notification.Name("refreshFeedView"), object: nil)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func deselectAllButtonClicked(_ sender: Any) {
        FeedFilterViewController.filteredTags.removeAll()
        FeedFilterTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension FeedFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tags.count == 0 {
            return 1
        } else {
            return tags.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if tags.count == 0 {
            cell.textLabel?.text = "등록된 태그가 없습니다"
        } else {
            cell.textLabel?.text = tags[indexPath.row]
            if FeedFilterViewController.filteredTags.contains(tags[indexPath.row]){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: indexPath) {
            if tags.count != 0 {
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                    FeedFilterViewController.filteredTags.append(tags[indexPath.row])
                } else if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    if let index = FeedFilterViewController.filteredTags.firstIndex(of: tags[indexPath.row]) {
                        FeedFilterViewController.filteredTags.remove(at: index)
                    }
                }
            }
        }
        print("선택된 태그는 \(FeedFilterViewController.filteredTags)")
    }
}
