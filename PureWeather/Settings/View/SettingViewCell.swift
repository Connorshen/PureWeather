//
//  SettingViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/5.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class SettingViewCell: UITableViewCell {
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var textLb: UILabel!
    @IBOutlet weak var mView: UIView!
    var settingType = SettingType.TYPE_NONE
    var delegate :SettingCellClick? = nil
    func setInfo(item:NorSettingItem?,delegate:SettingCellClick?) {
        if let item = item{
            textLb.text = item.text
            rightArrow.isHidden = !(item.hasArrow)
            settingType = item.settingType
        }
        if let delegate = delegate {
            self.delegate = delegate
        }
        
        self.selectionStyle = .none
        mView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellClick)))
        mView.isUserInteractionEnabled=true
    }
    @objc func cellClick(){
        if let delegate = delegate{
            if settingType == SettingType.TYPE_REDEEM{
                delegate.onRedeemCodeClick()
            }else if settingType == SettingType.TYPE_ABOUT {
                delegate.onAboutClick()
            }
            else if settingType == SettingType.TYPE_CLEAR_DATA {
                delegate.onClearDataClick()
            }
        }
    }
}
protocol SettingCellClick {
    func onRedeemCodeClick()
    func onAboutClick()
    func onClearDataClick()
}
