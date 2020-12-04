//
//  AddSelectViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/31.
//

import UIKit


class AddSelectViewController: UIViewController {
    var tags: Array<String> = []
    var selectedTags: Array<String> = []

    @IBOutlet weak var createTagTextField: UITextField!
    @IBOutlet weak var createTagButton: UIButton!{
        didSet{
            createTagButton.layer.cornerRadius = createTagButton.frame.height/2
        }
    }
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
            selectedTags.append(createTagTextField.text!)
        }
        self.createTagTextField.text = ""
        self.createTagButton.backgroundColor = UIColor.gray
        self.view.endEditing(true)
        self.selectTagsTableView.reloadData()
    }
    
    func textFieldsSetUp() {
        createTagButton.backgroundColor = UIColor.gray
        createTagButton.isEnabled = false
        createTagTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard let tag = createTagTextField.text, !tag.isEmpty
          else {
            self.createTagButton.isEnabled = false
            self.createTagButton.backgroundColor = UIColor.gray
            return
        }
        createTagButton.isEnabled = true
        createTagButton.backgroundColor = UIColor(named: "SwitchingBlue")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsSetUp()
        createTagTextField.delegate = self
        createTagButton.isEnabled = false
        for tag in SharedData.instance.getTagListOfSelectedCharacter(){
            if !tags.contains(tag){
                tags.append(tag)
            }
        }
//        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.selectTagsTableView.reloadData()
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
            if selectedTags.contains(tags[indexPath.row]) {
                cell.accessoryType = .checkmark
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
                    selectedTags.append(tags[indexPath.row])
                } else if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    if let index = selectedTags.firstIndex(of: tags[indexPath.row]) {
                                selectedTags.remove(at: index)
                    }
                }
            }
        }
        self.view.endEditing(true)
    }
}

extension AddSelectViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 10
    }
}
extension AddSelectViewController {
// Ends editing view when touches to view
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      self.view.endEditing(true)
    }
}
