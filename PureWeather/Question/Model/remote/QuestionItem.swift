//
//  QuestionRemote.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/7.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class QuestionItem: LCObject {
    @objc dynamic var qid:LCNumber?
    @objc dynamic var msg:LCString?
    @objc dynamic var negativeAnswer:LCString?
    @objc dynamic var positiveAnswer:LCString?
    @objc dynamic var negativeNext:LCNumber?
    @objc dynamic var positiveNext:LCNumber?
    @objc dynamic var singleMode:LCBool?
    @objc dynamic var singleAnswer:LCString?
    @objc dynamic var singleNext:LCNumber?
    @objc dynamic var themeColor:LCString?
    @objc dynamic var positiveCmd:LCString?
    @objc dynamic var negativeCmd:LCString?
    @objc dynamic var singleCmd:LCString?
    override static func objectClassName() -> String {
        return "QuestionItem"
    }
    required init() {
        qid = LCNumber(-1)
        msg = LCString("")
        negativeAnswer = LCString("")
        positiveAnswer = LCString("")
        negativeNext = LCNumber(-1)
        positiveNext = LCNumber(-1)
        singleMode = LCBool(false)
        singleAnswer = LCString("")
        singleNext = LCNumber(-1)
        themeColor = LCString("")
        positiveCmd = LCString(QuestionCmd.CMD_NONE)
        negativeCmd = LCString(QuestionCmd.CMD_NONE)
        singleCmd = LCString(QuestionCmd.CMD_NONE)
    }
    required init(question:Question) {
        qid = LCNumber(Double(question.qid))
        msg = LCString(question.msg)
        negativeAnswer = LCString(question.negativeAnswer)
        positiveAnswer = LCString(question.positiveAnswer)
        negativeNext = LCNumber(Double(question.negativeNext))
        positiveNext = LCNumber(Double(question.positiveNext))
        singleMode = LCBool(question.singleMode)
        singleAnswer = LCString(question.singleAnswer)
        singleNext = LCNumber(Double(question.singleNext))
        themeColor = LCString(question.themeColor)
        positiveCmd = LCString(question.positiveCmd)
        negativeCmd = LCString(question.negativeCmd)
        singleCmd = LCString(question.singleCmd)
    }
}
