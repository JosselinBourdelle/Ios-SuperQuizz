//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizz
//
//  Created by formation12 on 05/12/2018.
//  Copyright © 2018 formation12. All rights reserved.
//

import UIKit

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController {
    
    var questionToEdit: Question?
    weak var delegate : CreateOrEditQuestionDelegate?
    var switchIsCheckMoment: UISwitch?
    
    // UI outlet
    @IBOutlet weak var questionTitleField: UITextField!
    @IBOutlet weak var answer1Field: UITextField!
    @IBOutlet weak var answer2Field: UITextField!
    @IBOutlet weak var answer3Field: UITextField!
    @IBOutlet weak var answer4Field: UITextField!
    @IBOutlet weak var correctAnswerSwitch1: UISwitch!
    @IBOutlet weak var correctAnswerSwitch2: UISwitch!
    @IBOutlet weak var correctAnswerSwitch3: UISwitch!
    @IBOutlet weak var correctAnswerSwitch4: UISwitch!
    
    @IBAction func tapSwitches(_ sender: UISwitch) {
        setSwitch(sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let question = questionToEdit {
            questionTitleField.text = question.title
            answer1Field.text = question.propositions[0]
            answer2Field.text = question.propositions[1]
            answer3Field.text = question.propositions[2]
            answer4Field.text = question.propositions[3]
            switch question.correctAnswer {
            case question.propositions[0] :
                setSwitch(sender: correctAnswerSwitch1)
                break
            case question.propositions[1] :
                setSwitch(sender: correctAnswerSwitch2)
                break
            case question.propositions[2] :
                setSwitch(sender: correctAnswerSwitch3)
                break
            case question.propositions[3] :
                setSwitch(sender: correctAnswerSwitch4)
                break
            case .none: break
            case .some(_): break
            }
            
        }
        
        
    }
    @IBAction func onOkTapped(_ sender: UIButton) {
        createOrEditQuestion()
    }
    
    func createOrEditQuestion() {
        if let question = questionToEdit {
            fillQuestion(question: question)
            delegate?.userDidEditQuestion(q: question)
        } else {
            //TODO creer une vnouvelle question
            let question = Question("")
            fillQuestion(question: question)
            delegate?.userDidCreateQuestion(q: question)
        }
    }
    
    func setSwitch(sender: UISwitch) {
        correctAnswerSwitch1.setOn(false, animated: true)
        correctAnswerSwitch2.setOn(false, animated: true)
        correctAnswerSwitch3.setOn(false, animated: true)
        correctAnswerSwitch4.setOn(false, animated: true)
        sender.setOn(true, animated: true)
        self.switchIsCheckMoment = sender
    }
    
    func fillQuestion(question: Question) {
        question.title = questionTitleField.text
        question.propositions.removeAll()
        question.propositions.append(answer1Field.text ?? "")
        question.propositions.append(answer2Field.text ?? "")
        question.propositions.append(answer3Field.text ?? "")
        question.propositions.append(answer4Field.text ?? "")
        switch switchIsCheckMoment {
        case correctAnswerSwitch1 :
            question.correctAnswer = question.propositions[0]
            break
        case correctAnswerSwitch2 :
            question.correctAnswer = question.propositions[1]
            break
        case correctAnswerSwitch3 :
            question.correctAnswer = question.propositions[2]
            break
        case correctAnswerSwitch4 :
            question.correctAnswer = question.propositions[3]
            break
        case .none: break
        case .some(_): break
        }
    }
    
}
