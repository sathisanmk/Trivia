//
//  ViewController.swift
//  Trivia
//
//  Created by Sathishkumar Muthukumar on 05/10/20.
//  Copyright © 2020 Sathishkumar Muthukumar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var historyButton:UIButton!
    
    var questionNumber = 0
    let nameTextField = UITextField()
    let questionLabel = UILabel()
    let optionsTableview = UITableView()
    var questionsModel = [QuestionModel]()
    var userAnswer = GameData()
    var questionData1 = QuestionData()
    var questionData2 = QuestionData()
    
    var selectedAnswer = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        optionsTableview.register(UINib(nibName: "OptionsTableViewCell", bundle: .main), forCellReuseIdentifier: "OptionsTableViewCell")
        nameTextField.delegate = self
        
        //Parsing JSON to our custom type
        let decoder = JSONDecoder()
        do {
            questionsModel = try decoder.decode([QuestionModel].self, from: json)
            getQuestion()
        } catch let error  {
            print("Parsing Failed \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        switch questionsModel[questionNumber].type{
            // Textfield typing questions
        case "FILL":
            if nameTextField.text?.count == 0 {
                showAlert("Please enter your name")
            }else{
                questionNumber += 1
                getQuestion()
                historyButton.isHidden = true
            }
            // Choose one
        case "MULTI_CHOICE":
            if questionData1.answer.count == 0 {
                showAlert("Please select answer")
            }else{
                questionNumber += 1
                getQuestion()
            }
            // Choose multiple
        default:
            if questionData2.answer.count == 0 {
                showAlert("Please select answer")
            }else{
                //This is the User answered data, passing this data to summary Viewcontroller
                let userData = userAnswer.questionData
                userData.append(questionData1)
                userData.append(questionData2)
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let vc = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
                vc.gameData = userAnswer
                vc.modalPresentationStyle = .fullScreen
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                view.window!.layer.add(transition, forKey: kCATransition)
                present(vc, animated: true)
            }
        }
    }
    
    // View previous played history
    @IBAction func historyAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: true)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        userAnswer.firstName = textField.text!
        if textField.text?.count == 0{
            showAlert("Please enter your name")
        }
    }
    
    //Get test questions and update the UI based on question type
    func getQuestion(){
        switch questionNumber {
        case 0:
            setupQuestionLabel(question: questionsModel[0].question)
            setupNameTextfield()
        case 1:
            nameTextField.removeFromSuperview()
            questionLabel.text = questionsModel[1].question
            setupTableview()
            DispatchQueue.main.async {
                self.optionsTableview.reloadData()
            }
        default:
            questionLabel.text = questionsModel[2].question
            DispatchQueue.main.async {
                self.optionsTableview.reloadData()
            }
        }
    }
    
}


//Tableview for displaying answer options to choose
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsModel[questionNumber].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell") as! OptionsTableViewCell
        let data = questionsModel[questionNumber]
        cell.checkBox.image = UIImage(named: "uncheck")
        cell.answer.text = data.answers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        let data = questionsModel[questionNumber]
        let questionType = data.type
        if questionType == "MULTI_CHOICE"{
            print(data.answers[indexPath.row])
            //convert the user answer to Realm object model for storing in Realm
            questionData1 = QuestionData(question: data.question, answer: data.answers[indexPath.row])
            cell.checkBox.image = UIImage(named: "check")
        }else{
            tableView.allowsMultipleSelection = true
            selectedAnswer.append(data.answers[indexPath.row])
            //convert the user answer to Realm object model for storing in Realm
            questionData2 = QuestionData(question: data.question, answer: Array(Set(selectedAnswer)).joined(separator: ","))
            cell.checkBox.image = UIImage(named: "check")
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
                let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        cell.checkBox.image = UIImage(named: "uncheck")

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension HomeViewController{
    
    // This is a label for displaying all questions
    func setupQuestionLabel(question:String){
        view.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.numberOfLines = 0
        questionLabel.textColor = .black
        questionLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        questionLabel.text = question
        questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30).isActive = true
        questionLabel.topAnchor.constraint(equalTo: appTitle.topAnchor, constant: 80).isActive = true
    }
    
    
    //This is a textfield for capturing user name
    func setupNameTextfield(){
        view.addSubview(nameTextField)
        addPadding(to: nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .gray
        nameTextField.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        nameTextField.placeholder = "Enter your name"
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.cornerRadius = 8
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30).isActive = true
        nameTextField.topAnchor.constraint(equalTo: questionLabel.topAnchor, constant: 50).isActive = true
    }
    
    //add left padding to the textfield
    func addPadding(to textfield: UITextField) {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }
    
    //This is a tableview setup for displaying answer options
    func setupTableview(){
        view.addSubview(optionsTableview)
        optionsTableview.dataSource = self
        optionsTableview.delegate = self
        optionsTableview.translatesAutoresizingMaskIntoConstraints = false
        optionsTableview.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        optionsTableview.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30).isActive = true
        optionsTableview.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10).isActive = true
        optionsTableview.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30).isActive = true
    }
    
    //Remove the view based on question type
    func removeButtonFromView(){
        nextButton.removeFromSuperview()
    }
    
    func removeTableview(){
        optionsTableview.removeFromSuperview()
    }
}

extension UIViewController{
    // Displaying Alert
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Trivia App", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

