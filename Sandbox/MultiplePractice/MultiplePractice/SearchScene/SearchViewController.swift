//
//  SearchViewController.swift
//  MultiplePractice
//
//  Created by JNGSJN on 2020/10/10.
//

import UIKit
struct Feed {
    var Title: String
}
var feeds: Array<Feed> = [Feed(Title: "첫번째 피드입니다. 사과🍎"),
                          Feed(Title: "두번째 피드입니다. 포도🍇"),
                          Feed(Title: "세번째 피드입니다. 수박🍉"),
                          Feed(Title: "네번째 피드입니다. 레몬🍋"),
                          Feed(Title: "다섯번째 피드입니다. 귤🍊"),
                          Feed(Title: "여섯번째 피드입니다. 딸기🍓")]

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath)
        cell.textLabel?.text = feeds[indexPath.row].Title
        return cell
    }
    
    
//    @IBAction func unwindFeed (segue : UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        searchTableView.dataSource = self
        searchTableView.delegate = self
        // Do any additional setup after loading the view.
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
