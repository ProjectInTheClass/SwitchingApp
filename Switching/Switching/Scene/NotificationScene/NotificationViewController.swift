//
//  NotificationViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/04.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    struct Notification {
        var character: String
        var feedCount: Int
        var days: Int
    }
    
    var notifications = [Notification(character: "본캐", feedCount: 2, days: 4),
                         Notification(character: "본캐", feedCount: 1, days: 2),
                         Notification(character: "부캐", feedCount: 2, days: 1),]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        cell.notificationTextLabel?.text = "임시보관함에 저장한 \(notifications[indexPath.row].character)의 북마크 \(notifications[indexPath.row].feedCount)개가 \(notifications[indexPath.row].days)일 뒤에 사라질 예정입니다."
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
