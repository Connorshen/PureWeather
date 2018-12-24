//
//  QuestionController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/7.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import SCLAlertView
class QuestionController: BaseController {
    var currentQuestion:Question? = nil
    var startTime:Date = Date()
    var endTime:Date = Date()
    var questions:[Question] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    func initView() -> Void {
    }
    func initData() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(onGetQuestion), name: QuestionMgr.KEY_GET_QUESTION_SUCCESSFUL, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onGetQuestionFailed), name: QuestionMgr.KEY_GET_QUESTION_FAILED, object: nil)
        let mode = QuestionMgr.shared.questionConfig.mode
        if mode == QuestionMode.MODE_SUCCESS{
            
        }else if mode == QuestionMode.MODE_ANSWER{
            QuestionMgr.shared.getQuestion()
        }
    }
    func addEvent(question:Question,eventType:String){
        let dur = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        let durStr = String(format:"%.2f",dur)
        var msg2 = ""
        switch eventType {
        case Event.POSITIVE_CLICK:
            msg2 = "\(question.msg):\(question.positiveAnswer)"
            break
        case Event.NEGATIVE_CLICK:
            msg2 = "\(question.msg):\(question.negativeAnswer)"
            break
        case Event.SINGLE_CLICK:
            msg2 = "\(question.msg):\(question.singleAnswer)"
            break
        default:
            break
        }
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: eventType, msg1: "用时\(durStr)s",msg2:msg2, packageName: getPackageName())
    }
    @objc func negativeClick(){
        if let question = currentQuestion{
            endTime = Date()
            addEvent(question: question,eventType: Event.NEGATIVE_CLICK)
            if question.negativeCmd != QuestionCmd.CMD_NONE{
                if question.negativeCmd == QuestionCmd.CMD_SET_MODE_FAILED{
                    QuestionMgr.shared.setQuestionCfg(questionMode: QuestionMode.MODE_FAILED, password: QuestionMode.DEFAULT_PASSWORD)
                }else if question.negativeCmd == QuestionCmd.CMD_SET_MODE_SUCCESS{
                    QuestionMgr.shared.setQuestionCfg(questionMode: QuestionMode.MODE_SUCCESS, password: QuestionMode.DEFAULT_PASSWORD)
                }
            }
            var isFind = false
            for q in questions{
                if question.negativeNext == q.qid{
                    currentQuestion = q
                    showQuestion()
                    isFind = true
                    break
                }
            }
            if !isFind{
                currentQuestion = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func positiveClick(){
        if let question = currentQuestion{
            endTime = Date()
            addEvent(question: question,eventType: Event.POSITIVE_CLICK)
            if question.positiveCmd != QuestionCmd.CMD_NONE{
                if question.positiveCmd == QuestionCmd.CMD_SET_MODE_FAILED{
                    QuestionMgr.shared.setQuestionCfg(questionMode: QuestionMode.MODE_FAILED, password: QuestionMode.DEFAULT_PASSWORD)
                }else if question.positiveCmd == QuestionCmd.CMD_SET_MODE_SUCCESS{
                    QuestionMgr.shared.setQuestionCfg(questionMode: QuestionMode.MODE_SUCCESS, password: QuestionMode.DEFAULT_PASSWORD)
                }
            }
            var isFind = false
            for q in questions{
                if question.positiveNext == q.qid{
                    currentQuestion = q
                    showQuestion()
                    isFind = true
                    break
                }
            }
            if !isFind{
                currentQuestion = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func singleClick(){
        if let question = currentQuestion{
            endTime = Date()
            addEvent(question: question,eventType: Event.SINGLE_CLICK)
            if question.singleCmd != QuestionCmd.CMD_NONE{
                if question.singleCmd == QuestionCmd.CMD_SET_MODE_FAILED{
                    QuestionMgr.shared.setQuestionCfg(questionMode: QuestionMode.MODE_FAILED, password: QuestionMode.DEFAULT_PASSWORD)
                }else if question.singleCmd == QuestionCmd.CMD_SET_MODE_SUCCESS{
                    QuestionMgr.shared.setQuestionCfg(questionMode: QuestionMode.MODE_SUCCESS, password: QuestionMode.DEFAULT_PASSWORD)
                }
            }
            var isFind = false
            for q in questions{
                if question.singleNext == q.qid{
                    currentQuestion = q
                    showQuestion()
                    isFind = true
                    break
                }
            }
            if !isFind{
                currentQuestion = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func showQuestion(){
        if let question = currentQuestion{
            startTime = Date()
            let appearance = SCLAlertView.SCLAppearance(
                kCircleIconHeight: 55,
                showCloseButton: false,
                showCircularIcon: true
            )
            let alertView = SCLAlertView(appearance: appearance)
            if question.singleMode{
                alertView.addButton(question.singleAnswer, target:self, selector:#selector(singleClick))
            }else{
                alertView.addButton(question.positiveAnswer, target:self, selector:#selector(positiveClick))
                alertView.addButton(question.negativeAnswer, target:self, selector:#selector(negativeClick))
            }
            let alertViewIcon = UIImage(named: "ic_bill")
            var result:UInt32 = 0
            Scanner(string: question.themeColor).scanHexInt32(&result)
            let themeColor = UIColor(valueRGB: UInt(result), alpha: 1.0)
            alertView.showCustom("", subTitle: question.msg, color: themeColor, icon: alertViewIcon!)
        }
    }
    @objc func onGetQuestion(){
        questions = QuestionMgr.shared.questions
        var rootQuestion:Question? = nil
        var isFind = false
        for question in questions{
            if question.qid == QuestionCmd.START_QID {
                rootQuestion = question
                isFind = true
                break
            }
        }
        if isFind{
            currentQuestion = rootQuestion
            showQuestion()
        }
    }
    @objc func onGetQuestionFailed(){
        self.dismiss(animated: true, completion: nil)
    }
}
import UIKit

extension UIColor {
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

