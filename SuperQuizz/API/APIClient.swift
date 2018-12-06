//
//  APIClient.swift
//  SuperQuizz
//
//  Created by formation12 on 06/12/2018.
//  Copyright © 2018 formation12. All rights reserved.
//

import Foundation

class APIClient {
    
    private init() {
        
    }
    
    static let instance = APIClient()
    
    private let urlServer = "http://192.168.10.171:3000"
    
    func getAllQuestionsFromServer(onSuccess:@escaping ([Question])->(), onError:@escaping (Error)->())-> URLSessionTask {
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                var questionsToreturn = [Question]()
                
                for object in dataArray {
                    let objectDictionary = object as! [String:Any]
                    let q  = Question("")
                    q.title = (objectDictionary["title"] as! String)
                    q.addPropostions(answer: objectDictionary["answer_1"] as! String)
                    q.addPropostions(answer: objectDictionary["answer_2"] as! String)
                    q.addPropostions(answer: objectDictionary["answer_3"] as! String)
                    q.addPropostions(answer: objectDictionary["answer_4"] as! String)
                    q.correctAnswer = q.propositions[(objectDictionary["correct_answer"] as! Int)-1]
                    q.authorName = (objectDictionary["author"] as! String)
                    q.imageAuthorUrl = (objectDictionary["author_img_url"] as! String)
                    q.idquestion = (objectDictionary["id"] as! Int)
                    questionsToreturn.append(q)
                }
                onSuccess(questionsToreturn)
            } else  {
                onError(error!)
            }
        }
        task.resume()
        return task
    }
    
    
    func addQuestionToServeur(questionToAdd: Question, onSuccess:@escaping (Question)->(), onError:@escaping (Error)->()) -> URLSessionTask {
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        let questionToJSON = [  "title" : questionToAdd.title!,
                                "answer_1" : questionToAdd.propositions[0],
                                "answer_2" : questionToAdd.propositions[1],
                                "answer_3" : questionToAdd.propositions[2],
                                "answer_4" : questionToAdd.propositions[3],
                                "correct_answer" : addNumberOfCorrectAnswer(question: questionToAdd),
                                "author" : "josselin",
                                "author_img_url" : "https://img.ohmymag.com/article/480/humour/mr-bean-s-incruste-dans-avatar_8d73c59406e9ab1833b2cb3cb403bf93ee3dfe26.jpg"] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: questionToJSON, options: .sortedKeys) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                onSuccess(questionToAdd)
            } else  {
                onError(error!)
            }
        }
        task.resume()
        return task
    }
    
    func updateQuestionToServeur(questionToUpdate: Question, onSuccess:@escaping (Question)->(), onError:@escaping (Error)->()) -> URLSessionTask {
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(questionToUpdate.idquestion!)")! )
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let questionToJSON = [  "id" : questionToUpdate.idquestion!,
                                "title" : questionToUpdate.title!,
                                "answer_1" : questionToUpdate.propositions[0],
                                "answer_2" : questionToUpdate.propositions[1],
                                "answer_3" : questionToUpdate.propositions[2],
                                "answer_4" : questionToUpdate.propositions[3],
                                "correct_answer" : addNumberOfCorrectAnswer(question: questionToUpdate),
                                "author" : questionToUpdate.authorName!,
                                "author_img_url" : questionToUpdate.imageAuthorUrl] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: questionToJSON, options: .sortedKeys) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                onSuccess(questionToUpdate)
            } else  {
                onError(error!)
            }
        }
        task.resume()
        return task
    }
    
    func deleteQuestionToServeur(questionToDelete: Question, onSuccess:@escaping (Question)->(), onError:@escaping (Error)->()) -> URLSessionTask {
        
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(questionToDelete.idquestion!)")! )
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let questionToJSON = [  "id" : questionToDelete.idquestion!,
                                "title" : questionToDelete.title!,
                                "answer_1" : questionToDelete.propositions[0],
                                "answer_2" : questionToDelete.propositions[1],
                                "answer_3" : questionToDelete.propositions[2],
                                "answer_4" : questionToDelete.propositions[3],
                                "correct_answer" : addNumberOfCorrectAnswer(question: questionToDelete),
                                "author" : questionToDelete.authorName!,
                                "author_img_url" : questionToDelete.imageAuthorUrl!] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: questionToJSON, options: .sortedKeys) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                onSuccess(questionToDelete)
            } else  {
                onError(error!)
            }
        }
        task.resume()
        return task
    }
    
    
    func addNumberOfCorrectAnswer(question : Question) -> Int {
        for i in 0..<4 {
            if question.propositions[i] == question.correctAnswer {
                return i+1
            }
        }
        return 1
    }
}
