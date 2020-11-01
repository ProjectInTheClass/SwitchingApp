//
//  AddSelectViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/31.
//

import UIKit


class AddSelectViewController: UIViewController {
    var tags: Array<String> = SharedData.instance.getTagListOfSelectedCharacter()
    var selectedIndexPathRows: Array<Int> = [] //임시데이터
    var selectedTags: Array<String> = [] //임시데이터

    @IBOutlet weak var createTagTextField: UITextField!
    @IBOutlet weak var createTagButton: UIButton!
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToAddVC", sender: sender)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAddVC" {
            let vc = segue.destination as? AddViewController
            vc!.selectedTags = selectedTags
        }
        print("AddVC로 데이터 이동")
    }
    
    @IBOutlet weak var selectTagsTableView: UITableView!
    @IBAction func createTagClicked(_ sender: Any) {
        if !tags.contains(createTagTextField.text!){
            tags.append(createTagTextField.text!)
        }
        self.selectTagsTableView.reloadData()
    }
    
    func textFieldsSetUp() {
        createTagButton.isEnabled = false
        createTagTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
    }
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard let tag = createTagTextField.text, !tag.isEmpty
          else {
          self.createTagButton.isEnabled = false
          return
        }
        createTagButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsSetUp()
        createTagButton.isEnabled = false
//        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.selectTagsTableView.reloadData()
        print("\(selectedIndexPathRows)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddSelectViewController: UITableViewDelegate, UITableViewDataSource {
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
        if selectedIndexPathRows.contains(indexPath.row) {
            cell.accessoryType = .checkmark
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
        selectedIndexPathRows.append(indexPath.row)
        print("선택된 태그는 \(selectedIndexPathRows)")
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
        if let index = selectedIndexPathRows.firstIndex(of: indexPath.row) {
            selectedIndexPathRows.remove(at: index)
        }
        print("선택된 태그는 \(selectedIndexPathRows)")
    }
}
