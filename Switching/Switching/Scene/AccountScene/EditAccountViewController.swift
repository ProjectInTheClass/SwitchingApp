//
//  EditAccountViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/16.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    @IBOutlet weak var accountImage: UIImageView!{
        didSet{
            accountImage.layer.cornerRadius = accountImage.frame.height/2
            accountImage.layer.borderWidth = 1.0
            accountImage.layer.borderColor = UIColor.gray.cgColor
            accountImage.clipsToBounds = true
            accountImage.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoButtonTapped))
            accountImage.addGestureRecognizer(tapGesture)
            if let account = editAccount{
                if let imageData = account.image{
                    accountImage.image = UIImage(data: imageData)
                }
            }
        }
    }
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var summitButton: UIButton!

    @IBOutlet weak var removeAccountBtn: UIButton!{
        didSet{
            removeAccountBtn.layer.borderColor = UIColor.systemRed.cgColor
            removeAccountBtn.layer.borderWidth = 1.5
            removeAccountBtn.layer.cornerRadius = removeAccountBtn.frame.height/2
        }
    }
    
    var image: UIImage?
    var editAccount: Character?
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard let name = accountTextField.text, !name.isEmpty else {
            self.summitButton.isEnabled = false
            return
        }
        summitButton.isEnabled = true
    }
    
    func textFieldsSetup() {
        if let account = editAccount{
            accountTextField.text = account.character
            summitButton.isEnabled = true
        }else{
            summitButton.isEnabled = false
        }
        accountTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }
    
    @objc func photoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(
                title: "사진 촬영",
                style: .default,
                handler: { (_) in
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(
                title: "이미지 선택하기",
                style: .default,
                handler: { (_) in
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                })
            alertController.addAction(photoLibraryAction)
        }
        
        if image != nil {
            let deleteAction = UIAlertAction(
                title: "이미지 삭제하기",
                style: .default,
                handler: { (_) in
                    self.image = nil
                    self.accountImage.image = nil
                })
            alertController.addAction(deleteAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidcancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func removeAccountHandler(alert: UIAlertAction!) {
        let realm = SharedData.instance.realm
        let bookmarks = realm.objects(Bookmark.self).filter("character = '\(editAccount!.character)'")
        try! realm.write{
            realm.delete(editAccount!)
            for bookmark in bookmarks{
                realm.delete(bookmark)
            }
        }
        if let character = realm.objects(Character.self).first{
            SharedData.instance.selectedCharacter = character.character
        }
        NotificationCenter.default.post(name: Notification.Name("refreshFeedView"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("refreshDraftView"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("newCharacterCreated"), object: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeClicked(_ sender: Any) {
        let alert = UIAlertController(title: "캐릭터를 삭제하시겠습니까?", message: "캐릭터에 저장된 모든 북마크가 사라지고 복구할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: removeAccountHandler(alert:))
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func summitClicked(_ sender: Any) {
        print("summit")
        let realm = SharedData.instance.realm
        if let newCharacterName = accountTextField.text{
            var isSameNameCharacterExist = false
            
            if let account = editAccount{
                if(realm.objects(Character.self).filter("character = '\(newCharacterName)'").count > 0 && newCharacterName != account.character){
                    isSameNameCharacterExist = true
                }
            }else{
                if(realm.objects(Character.self).filter("character = '\(newCharacterName)'").count > 0){
                    isSameNameCharacterExist = true
                }
            }
            
            if isSameNameCharacterExist{
                // Create new Alert
                 var dialogMessage = UIAlertController(title: "캐릭터 이름 중복", message: "같은 이름의 캐릭터를 생성할 수 없습니다.", preferredStyle: .alert)
                 
                 // Create OK button with action handler
                 let ok = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
                     print("Ok button tapped")
                  })
                 
                 //Add OK button to a dialog message
                 dialogMessage.addAction(ok)
                 // Present Alert to
                 self.present(dialogMessage, animated: true, completion: nil)
                return
            }
        }
        if let account = editAccount{
            print("수정")
            let realm = SharedData.instance.realm
            let bookmarks = realm.objects(Bookmark.self).filter("character = '\(editAccount!.character)'")
            do{
                try realm.write{
                    if let newText = accountTextField.text{
                        account.character = newText
                        for bookmakr in bookmarks{
                            bookmakr.character = newText
                        }
                        SharedData.instance.selectedCharacter = newText
                    }
                    if let newImage = self.image?.pngData(){
                        account.image = newImage
                    }
                 }
            } catch{
                print("Error Edit \(error)")
            }
            NotificationCenter.default.post(name: Notification.Name("refreshFeedView"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("refreshDraftView"), object: nil)
        }
        else{
            print("생성")
            guard let text = accountTextField.text
            else{ return }
            let newCharacter = Character()
            newCharacter.character = text
            if let image = self.image?.pngData(){
                newCharacter.image = image
            }else{
                newCharacter.image = nil
            }
            
            let realm = SharedData.instance.realm
            do{
                try realm.write{
                    realm.add(newCharacter)
                }
            } catch {
                print("Error Add \(error)")
            }
        }
        NotificationCenter.default.post(name: Notification.Name("newCharacterCreated"), object: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        accountTextField.delegate = self
        textFieldsSetup()
        if editAccount == nil{
            removeAccountBtn.removeFromSuperview()
        }
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

extension EditAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            accountImage.image = imageSelected
            print(imageSelected)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditAccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 10
    }
}
