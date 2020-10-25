
import UIKit

class AthleteFormViewController: UIViewController {

    struct PropertyKeys {
        static let unwind = "UnwindToAthleteTable"
    }
    
    var athlete: Athlete?
    
    func appendData() {
        tags = ["UX디자인", "UIKit", "swift", "CSS", "HTML", "JS", "디자인소스", "GUI"]
    }
    
//    func tagsSelected() -> Array<Tag> {
//        return tags.filter{$0.isSelected == true}
//    }
//    func tagsSelectedName() -> Array<String>? {
//        return tagsSelected().map{$0.name}
//    }
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var leagueTextField: UITextField!
    @IBOutlet var teamTextField: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendData()
        updateView()
    }
    override func viewWillAppear(_ animated: Bool) {
        tagCollectionView.reloadData()
    }
    
    func updateView() {
        guard let athlete = athlete else {return}
        
        nameTextField.text = athlete.name
        ageTextField.text = athlete.age
        leagueTextField.text = athlete.league
        teamTextField.text = athlete.team
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            let age = ageTextField.text,
            let league = leagueTextField.text,
            let team = teamTextField.text
            else {return}
        
        athlete = Athlete(name: name, age: age, league: league, team: team, selectedtags: tags)
        performSegue(withIdentifier: PropertyKeys.unwind, sender: self)
        print(athlete)
    }

}

extension AthleteFormViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tagCount = tags.count
        if tagCount == 0 {
            return 1
        } else {
            return tagCount
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell",
                                                            for: indexPath) as? TagCollectionViewCell
        else {
            return TagCollectionViewCell()
        }
        let tagCount = tags.count
        if tagCount == 0 {
            cell.tagButton?.setTitle("지정된 태그가 없습니다", for: .normal)
            cell.contentView.layer.backgroundColor = UIColor.white.cgColor
            cell.contentView.tintColor = UIColor.black
        } else {
            cell.tagButton?.setTitle(tags[indexPath.row], for: .normal)
            cell.contentView.layer.backgroundColor = UIColor.black.cgColor
            cell.contentView.tintColor = UIColor.white
        }
        cell.update()
        return cell
    }
    
    
}
