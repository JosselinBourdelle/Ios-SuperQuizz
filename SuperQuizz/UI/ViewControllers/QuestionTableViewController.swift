//
//  QuestionTableViewController.swift
//  SuperQuizz
//
//  Created by formation12 on 04/12/2018.
//  Copyright © 2018 formation12. All rights reserved.
//

import UIKit

class QuestionTableViewController: UITableViewController {

    var questions: [Question] = [Question]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        APIClient.instance.getAllQuestionsFromServer(onSuccess: { (questions) in
            self.questions = questions
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
        }, onError: { (error) in
            print(error)
        })
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        var str: String = ""
        
        if(indexPath.row < questions.count){
            str = questions[indexPath.row].title ??  ""
            if let userAnswer = questions[indexPath.row].userChoice{
                if userAnswer == questions[indexPath.row].correctAnswer{
                    cell.backgroundColor = UIColor(red:0.05, green:0.68, blue:0.41, alpha:1.0)
                    
                }
                else {
                     cell.backgroundColor = UIColor(red:0.93, green:0.26, blue:0.40, alpha:1.0)
                }
            }
        }
        cell.QuestionTitleLabel.text = str
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
        controller.question = questions[indexPath.row]
        
        controller.setOnProgressTimeOut {
            controller.work?.cancel()
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
        
        controller.setOnReponseAnswered { (questionAnswered, result) in
            //TODO : Mettre à jour la liste, ou faire un appel reseau, ou mettre à jour la base
            controller.work?.cancel()
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
        self.show(controller, sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrEditQuestionViewController") as! CreateOrEditQuestionViewController
            controller.delegate = self
            controller.questionToEdit = self.questions[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            //TODO: delete in database
            APIClient.instance.deleteQuestionToServeur(questionToDelete: self.questions[indexPath.row], onSuccess: { (question) in
                DispatchQueue.main.async {
                    self.questions.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }, onError: { (error) in
                print(error)
            })
            
            
        }
        return [editAction,deleteAction]
    }
    
    func getListQuestion() -> [Question] {
        var questions: [Question] = [Question]()
        
        let question: Question = Question("Quelle est la capitale de la france ?")
        question.addPropostions(answer: "Paris")
        question.addPropostions(answer: "Nantes")
        question.addPropostions(answer: "Berlin")
        question.addPropostions(answer: "Washington")
        question.correctAnswer = "Nantes"
        questions.append(question)
        
        let question2: Question = Question("Quelle est la capitale de L'allemagne ?")
        question2.addPropostions(answer: "Paris")
        question2.addPropostions(answer: "Nantes")
        question2.addPropostions(answer: "Berlin")
        question2.addPropostions(answer: "Washington")
        question2.correctAnswer = "Berlin"
        questions.append(question2)
        
        let question3: Question = Question("Quelle est la capitale of AMERiCAAA !?")
        question3.addPropostions(answer: "Paris")
        question3.addPropostions(answer: "Nantes")
        question3.addPropostions(answer: "Berlin")
        question3.addPropostions(answer: "Washington")
        question3.correctAnswer = "Washington"
        questions.append(question3)
        
        return questions
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateOrEditViewController" {
            let controller = segue.destination as! CreateOrEditQuestionViewController
            controller.delegate = self
        }
    }
}

extension QuestionTableViewController : CreateOrEditQuestionDelegate {
    func userDidEditQuestion(q: Question) {
        APIClient.instance.updateQuestionToServeur(questionToUpdate: q, onSuccess: { (question) in
            for i in 0..<self.questions.count {
                if self.questions[i].idquestion == q.idquestion{
                    self.questions[i] = q
                }
            }
            DispatchQueue.main.async {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    func userDidCreateQuestion(q: Question) {
        APIClient.instance.addQuestionToServeur(questionToAdd: q, onSuccess: { (question) in
            DispatchQueue.main.async {
                
                guard let presentedVC = self.presentedViewController else {
                    return
                }
                self.questions.append(q)
                presentedVC.modalTransitionStyle = .crossDissolve
                presentedVC.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
       
    }
    
    
}
