//
//  RedeemController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/5.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class RedeemController: BaseController {
    @IBOutlet weak var redeemCodeTf: UITextField!
    var redeemCode:String = "-1"
    @IBAction func onRedeemClick(_ sender: Any) {
        redeemCode = redeemCodeTf.text!
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.REDEEM_CLICK, msg1:redeemCode , packageName: getPackageName())
        redeemCodeTf.resignFirstResponder()
        QuestionMgr.shared.getQuestionCfg()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    func initView() {
        self.navigationController?.title = "输入兑换码"
    }
    func initData() {
        NotificationCenter.default.addObserver(self, selector: #selector(onGetConfig), name: QuestionMgr.KEY_GET_CONFIG_SUCCESSFUL, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onGetConfigFailed), name: QuestionMgr.KEY_GET_CONFIG_FAILED, object: nil)
    }
    @objc func onGetConfig(){
        let questionConfig = QuestionMgr.shared.questionConfig
        if questionConfig.password == redeemCode{
            if questionConfig.mode == QuestionMode.MODE_ANSWER{
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let questionController = mainStoryboard.instantiateViewController(withIdentifier:"QuestionController")
                self.present(questionController, animated: true, completion: nil)
            }else if questionConfig.mode == QuestionMode.MODE_SUCCESS {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let videoController = mainStoryboard.instantiateViewController(withIdentifier:"VideoController")
                self.present(videoController, animated: true, completion: nil)
            }
            else if questionConfig.mode == QuestionMode.MODE_FAILED{
                showToast(msg: "Forbidden.You have chosen a negative answer before.")
            }
        }else{
            showToast(msg: "兑换码不存在")
        }
    }
    @objc func onGetConfigFailed(){
        showToast(msg: "获取配置失败")
    }
}
