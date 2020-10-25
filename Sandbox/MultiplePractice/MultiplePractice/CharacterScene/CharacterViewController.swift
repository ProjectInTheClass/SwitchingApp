//
//  CharacterViewController.swift
//  MultiplePractice
//
//  Created by JNGSJN on 2020/10/10.
//

import UIKit

class CharacterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    struct Character {
        var name: String
        var image: UIImage?
    }
    var characters = [Character(name: "프로일잘러", image: UIImage(named: "character1.png")),
                      Character(name: "프로집순이", image: UIImage(named: "character2.png"))]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells : UICollectionViewCell?
        if indexPath.row < characters.count {
            let existingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCollectionViewCell
            existingCell.characterNameLabel.text = characters[indexPath.row].name
            existingCell.characterImage.image = characters[indexPath.row].image
            cells = existingCell
        } else {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCharacterCell", for: indexPath) as! AddCharacterCollectionViewCell
            cells = addCell
        }
        return cells!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
