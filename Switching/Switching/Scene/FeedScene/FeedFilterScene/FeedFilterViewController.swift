//
//  FeedFilterlViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/30.
//

import UIKit

class FeedFilterViewController: UIViewController {
    
    var tags: Array<String> = SharedData.instance.getTagListOfSelectedCharacter()
    var filteredTags: Array<String> = [] //임시데이터
    
    @IBOutlet weak var FeedFilterTableView: UITableView!
    @IBAction func backButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToFeedVC", sender: sender)
        NotificationCenter.default.post(name: Notification.Name("refreshFeedView"), object: nil)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToFeedVC" {
            let vc = segue.destination as? FeedViewController
            vc!.filteredTags = filteredTags
        }
        print("feedVC로 데이터 이동")
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
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            }
        }
        filteredTags.append(tags[indexPath.row])
        print("선택된 태그는 \(filteredTags)")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
            }
        }
        if let index = filteredTags.firstIndex(of: tags[indexPath.row]) {
            filteredTags.remove(at: index)
        }
        print("선택된 태그는 \(filteredTags)")
    }
}
