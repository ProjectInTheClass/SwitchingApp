//
//  FeedFilterlViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/30.
//

import UIKit

class FeedFilterViewController: UIViewController {
    
    var tags: Array<String> = ["태그1번", "태그2번", "태그3번"] //임시데이터
    var selectedTags: Array<String> = [] //임시데이터
    
    @IBOutlet weak var FeedFilterTableView: UITableView!
    @IBAction func backButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToFeedVC", sender: sender)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToFeedVC" {
            let vc = segue.destination as? FeedViewController
            vc!.filteredTags = selectedTags
        }
        print("filteredTags로 데이터 이동")
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
        selectedTags.append(tags[indexPath.row])
        print("선택된 태그는 \(selectedTags)")
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
        print("선택된 태그는 \(selectedTags)")
    }
}
