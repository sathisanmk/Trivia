//
//  SummaryViewController.swift
//  Trivia
//
//  Created by Sathishkumar Muthukumar on 05/10/20.
//  Copyright © 2020 Sathishkumar Muthukumar. All rights reserved.
//

import UIKit
import RealmSwift

class SummaryViewController: UIViewController {
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    var gameData = GameData()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "AnswersTableViewCell", bundle: .main), forCellReuseIdentifier: "AnswersTableViewCell")
        let attributedString = NSMutableAttributedString(string: "Hello \(gameData.firstName)", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.black
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 121.0 / 255.0, green: 127.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0), range: NSRange(location: 0, length: 5))
        nameLabel.attributedText = attributedString
        
    }
    @IBAction func finishAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, h:mm a"
        let dateString = dateFormatter.string(from: Date())
        gameData.date = dateString
        print(dateString)
        let realm = try! Realm()
        try! realm.write{
            realm.add(gameData)
        }
        
        print(realm.isEmpty)
        
            let alert = UIAlertController(title: "Trivia App", message: "Game ended", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {action in
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }))
            self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: true)
        
    }
    
}



extension SummaryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameData.questionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswersTableViewCell") as! AnswersTableViewCell
        print(gameData.questionData[indexPath.row])
        cell.questionLabel.text = gameData.questionData[indexPath.row].question
        cell.answerLabel.text = gameData.questionData[indexPath.row].answer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


