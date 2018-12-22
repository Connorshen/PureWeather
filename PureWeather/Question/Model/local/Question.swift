//
//  Question.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/7.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class Question {
    var qid = -1
    var msg = ""
    var negativeAnswer = ""
    var positiveAnswer = ""
    var negativeNext = -1
    var positiveNext = -1
    var singleMode = false
    var singleAnswer = ""
    var singleNext = -1
    var themeColor = ""
    var positiveCmd = QuestionCmd.CMD_NONE
    var negativeCmd = QuestionCmd.CMD_NONE
    var singleCmd = QuestionCmd.CMD_NONE
    init(questionItem:QuestionItem?) {
        if let questionItem = questionItem{
            qid = Int((questionItem.qid?.value)!)
            msg = (questionItem.msg?.value)!
            negativeAnswer = (questionItem.negativeAnswer?.value)!
            positiveAnswer = (questionItem.positiveAnswer?.value)!
            negativeNext = Int((questionItem.negativeNext?.value)!)
            positiveNext = Int((questionItem.positiveNext?.value)!)
            singleMode = (questionItem.singleMode?.value)!
            singleAnswer = (questionItem.singleAnswer?.value)!
            singleNext = Int((questionItem.singleNext?.value)!)
            themeColor = (questionItem.themeColor?.value)!
            positiveCmd = (questionItem.positiveCmd?.value)!
            negativeCmd = (questionItem.negativeCmd?.value)!
            singleCmd = (questionItem.singleCmd?.value)!
        }
    }
}
