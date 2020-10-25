//
//  EditAccountViewController.swift
//  AccountPractice
//
//  Created by JNGSJN on 2020/10/21.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var summitButton: UIButton!
    
    var account: Account?
    var image: UIImage?
    
    func textFieldsSetUp() {
        summitButton.isEnabled = false
        accountTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
    }
    @objc func textFieldsIsNotEmpty(sender: UITextField) {

        guard let name = accountTextField.text, !name.isEmpty
          else {
          self.summitButton.isEnabled = false
          return
        }
        summitButton.isEnabled = true
    }
    
    func accountImageSetUp() {
        accountImage.layer.cornerRadius = 50
        accountImage.clipsToBounds = true
        accountImage.isUserInteractionEnabled = true
        accountImage.layer.borderWidth = 1.0
        accountImage.layer.borderColor = UIColor.gray.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoButtonTapped))
        accountImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func photoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "사진 촬영", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "이미지 선택하기", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        if image != nil {
            let deleteAction = UIAlertAction(title: "이미지 삭제하기", style: .destructive, handler: {(_) in
                self.image = nil
                self.accountImage.image = nil
            })
            alertController.addAction(deleteAction)
        }
        present(alertController, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func summitClicked(_ sender: Any) {
        guard let name = accountTextField.text,
              let image = self.image
            else {return}
        account = Account(name: name, image: image)
        accounts.append(account!)
        
        NotificationCenter.default.post(name: Notification.Name("newCharacterCreated"), object: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTextField.delegate = self
        textFieldsSetUp()
        accountImageSetUp()
    }
}
extension EditAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            accountImage.image = imageSelected
            print(imageSelected)
        }
//        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            image = imageOriginal
//            accountImage.image = imageOriginal
//            print(imageOriginal)
//        }
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
