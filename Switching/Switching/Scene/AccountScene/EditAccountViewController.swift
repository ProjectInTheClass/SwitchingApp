//
//  EditAccountViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/16.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var summitButton: UIButton!
    
    var account: Character?
    var image: UIImage?
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard let name = accountTextField.text, !name.isEmpty else {
            self.summitButton.isEnabled = false
            return
        }
        summitButton.isEnabled = true
    }
    
    func textFieldsSetup() {
        summitButton.isEnabled = false
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
    
    func accountImageSetUp() {
        accountImage.layer.cornerRadius = 50
        accountImage.layer.borderWidth = 1.0
        accountImage.layer.borderColor = UIColor.gray.cgColor
        accountImage.clipsToBounds = true
        accountImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoButtonTapped))
        accountImage.addGestureRecognizer(tapGesture)
    }
    
    func imagePickerControllerDidcancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func summitClicked(_ sender: Any) {
        guard let text = accountTextField.text,
              let image = self.image?.pngData()
        else{ return }
        let newCharacter = Character()
        newCharacter.character = text
        newCharacter.image = image
        
        let realm = SharedData.instance.realm
        do{
            try realm.write{
                realm.add(newCharacter)
            }
        } catch {
            print("Error Add \(error)")
        }
        NotificationCenter.default.post(name: Notification.Name("newCharacterCreated"), object: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        accountTextField.delegate = self
        textFieldsSetup()
        accountImageSetUp()
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
