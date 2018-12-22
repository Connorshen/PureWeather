//
//  LifeIndexViewCell.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/21.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import UIKit
class LifeIndexViewCell:UITableViewCell{
    @IBOutlet weak var valueLb: UILabel!
    @IBOutlet weak var detailLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    func setInfo(lifeIndexItem:LifeIndexItem) -> Void {
        valueLb.text=lifeIndexItem.value
        nameLb.text=lifeIndexItem.name
        detailLb.text=lifeIndexItem.detail
        self.selectionStyle = .none
    }
}
