//
//  SettingController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/5.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class SettingController: BaseController,UITableViewDelegate,UITableViewDataSource,SettingCellClick {
    let TYPE_NOR_SETTING = 1
    @IBOutlet weak var mListView: UITableView!
    var mItems:[BaseItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    func initView(){
        mListView.separatorStyle = .none
        mListView.register(UINib(nibName: "SettingViewCell", bundle: nil), forCellReuseIdentifier: "SettingViewCell")
        mListView.dataSource=self
        mListView.delegate=self
    }
    func initData(){
        updateList()
    }
    func updateList(){
        mItems.removeAll()
        mItems.append(NorSettingItem(itemType: TYPE_NOR_SETTING, text: "输入兑换码", hasArrow: true,settingType: SettingType.TYPE_REDEEM))
        mItems.append(NorSettingItem(itemType: TYPE_NOR_SETTING, text: "清空缓存", hasArrow: false,settingType: SettingType.TYPE_CLEAR_DATA))
        mListView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defalutCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        let baseItem:BaseItem=mItems[indexPath.row]
        switch baseItem.itemType {
        case TYPE_NOR_SETTING:
            let cell: SettingViewCell = self.mListView.dequeueReusableCell(withIdentifier: "SettingViewCell") as! SettingViewCell
            cell.setInfo(item: baseItem as? NorSettingItem,delegate: self)
            return cell
        default:
            return defalutCell
        }
    }
    @IBAction func onCloseClick(_ sender: Any) {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CLOSE_CLICK, packageName: getPackageName())
        self.dismiss(animated: true, completion: nil)
    }
    func onRedeemCodeClick() {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.REDEEM_ITEM_CLICK, packageName: getPackageName())
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let redeemController = mainStoryboard.instantiateViewController(withIdentifier:"RedeemController")
        self.navigationController?.pushViewController(redeemController , animated: true)
    }
    func onAboutClick() {
        
    }
    
    func onClearDataClick() {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CLEAR_DATA_ITEM_CLICK, packageName: getPackageName())
        showWaiting()
        DispatchQueue.global().asyncAfter(deadline: .now() + TimeInterval(0.5)) {
            DispatchQueue.main.async {
                self.hideWaiting()
                self.showToast(msg: "清除成功")
            }
        }
    }
}
