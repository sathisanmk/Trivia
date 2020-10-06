//
//  HistoryViewController.swift
//  Trivia
//
//  Created by Sathishkumar Muthukumar on 05/10/20.
//  Copyright © 2020 Sathishkumar Muthukumar. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableview:UITableView!
    var gameData = [GameData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "HistoryHeader", bundle: .main), forHeaderFooterViewReuseIdentifier: "HistoryHeader")
        tableview.register(UINib(nibName: "AnswersTableViewCell", bundle: .main), forCellReuseIdentifier: "AnswersTableViewCell")
        let realm = try! Realm()
        let historyData = realm.objects(GameData.self)
        gameData = historyData.toArray(ofType: GameData.self) as [GameData]
        tableview.isHidden = gameData.count == 0 ? true : false
    }
    
    //back to Home ViewController
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


//Displaying Previous played History
extension HistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameData[section].questionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswersTableViewCell") as! AnswersTableViewCell
        cell.questionLabel.text = gameData[indexPath.section].questionData[indexPath.row].question
        cell.answerLabel.text = gameData[indexPath.section].questionData[indexPath.row].answer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HistoryHeader") as! HistoryHeader
        header.date.text = gameData[section].date
        header.gameNo.text = "GAME \(section + 1)"
        header.name.text = gameData[section].firstName
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gameData.count
    }
    
    
}

//There is no Array available in realm, we can only append data to our custom type [GameData]
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}
