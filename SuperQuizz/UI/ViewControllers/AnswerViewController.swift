//
//  ViewController.swift
//  SuperQuizz
//
//  Created by formation12 on 04/12/2018.
//  Copyright © 2018 formation12. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    var question: Question!
    
    var onQuestionAnswered : ((_ q: Question,_ isCorrectAnswer: Bool)-> ())?
    
    var onProgressTimeOut : (() -> ())?
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var work: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        questionTitleLabel.text = question.title
        
        
        firstAnswer.setTitle(question.propositions[0] , for: .normal)
        secondAnswer.setTitle(question.propositions[1] , for: .normal)
        thirdAnswer.setTitle(question.propositions[2] , for: .normal)
        fourthAnswer.setTitle(question.propositions[3] , for: .normal)
        
        
        work = DispatchWorkItem {
            var count : Float = 0 ;
            while count < 1 {
                Thread.sleep(forTimeInterval: 0.01)
                DispatchQueue.main.async {
                    self.setProgress(float: count)
                }
                count += 0.001;
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.onProgressTimeOut?()
            }
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: work!)
        
        
    }
    
    func setProgress(float: Float) {
        self.progressBar.setProgress(float, animated: true)
    }
    
    @IBAction func answerButtonWasTapped(_ sender: UIButton) {
        question.userChoice = sender.titleLabel?.text
        if question.correctAnswer == sender.titleLabel?.text {
            userDidChooseAnswer(isCorrectAnswer: true)
        }
        else {
            userDidChooseAnswer(isCorrectAnswer: false)
        }
    }
    
    
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    func setOnProgressTimeOut(closure : @escaping () -> ()) {
        onProgressTimeOut = closure
    }
    
    func userDidChooseAnswer(isCorrectAnswer : Bool) {
        //TODO : Faire les animations de réussite ou d'échec
        var message: String
        var style : UIAlertAction.Style
        
        if isCorrectAnswer {
            message = " Bonne réponse !! "
            style = .default
        }
        else {
            message = " Mauvaise réponse !! "
            style = .destructive
        }
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok...", style: style, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.dismiss(animated: true, completion: nil)
            self.onQuestionAnswered?(self.question, isCorrectAnswer)
        }))
        self.present(alert, animated: true)
    }


}

