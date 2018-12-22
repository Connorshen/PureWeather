//
//  QuestionManager.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/7.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class QuestionMgr: BaseMgr {
    static let shared = QuestionMgr()
    static let KEY_GET_CONFIG_SUCCESSFUL = NSNotification.Name(rawValue:"key_get_config_successful")
    static let KEY_GET_CONFIG_FAILED = NSNotification.Name(rawValue:"key_get_config_failed")
    static let KEY_GET_QUESTION_SUCCESSFUL = NSNotification.Name(rawValue:"key_get_question_successful")
    static let KEY_GET_QUESTION_FAILED = NSNotification.Name(rawValue:"key_get_question_failed")
    var questionConfig = QuestionConfig()
    var questions:[Question] = []
    func getQuestionCfg(){
        let query = LCQuery(className: "QuestionCfg")
        query.find { result in
            switch result {
            case .success(let objects):
                if objects.count>0{
                    let object = objects[0]
                    if let questionCfg = object as? QuestionCfg{
                        self.questionConfig.mode = questionCfg.mode?.value
                        self.questionConfig.password = questionCfg.password?.value
                        self.sendMessage(name: QuestionMgr.KEY_GET_CONFIG_SUCCESSFUL, object: nil)
                    }
                }
                break
            case .failure:
                self.sendMessage(name: QuestionMgr.KEY_GET_CONFIG_FAILED, object: nil)
                break
            }
        }
    }
    func setQuestionCfg(questionMode:String?,password:String?){
        let query = LCQuery(className: "QuestionCfg")
        query.find { result in
            switch result {
            case .success(let objects):
                if objects.count>0{
                    for o in objects{
                        o.delete({ (result) in
                            switch result{
                            case .success:
                                let questionCfg = QuestionCfg()
                                if let questionMode = questionMode{
                                    questionCfg.setMode(mode:questionMode)
                                }
                                if let password = password{
                                    questionCfg.setPassword(password: password)
                                }
                                questionCfg.save { (result) in
                                    
                                }
                                break
                            case .failure:
                                break
                            }
                        })
                    }
                }
                break
            case .failure:
                break
            }
        }
    }
    func getQuestion(){
        let query = LCQuery(className: "QuestionItem")
        query.find() { result in
            switch result {
            case .success(let objects):
                self.questions = []
                for object in objects{
                    self.questions.append(Question(questionItem: object as? QuestionItem))
                }
                self.sendMessage(name: QuestionMgr.KEY_GET_QUESTION_SUCCESSFUL, object: nil)
                break
            case .failure(let error):
                print(error)
                self.sendMessage(name: QuestionMgr.KEY_GET_QUESTION_FAILED, object: nil)
                break
            }
        }
    }
}
