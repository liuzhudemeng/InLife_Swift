//
//  EunmeratDefine.swift
//  StoreSpace_Swift
//
//  Created by apple on 17/1/18.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

/**
 系统类型
 */
enum systemType: String {
    case isBsp = "bsp"  //
    case isWms = "wms"  //
}

//MARK:进入仓库申请状态
enum ApplyIntoStatu:Int {
    case noApproval = 1  //待监控中心审批
    case haveAbandoned = 2  //已撤防
    case haveProtection = 3 //已布防
    case refused = 4  //拒绝
    case delayedPending = 5 //申请延时，待审批
    case delayRefused = 6  //申请延迟,已拒绝
}

//MARK:申请查看单状态
enum ApplyLookUpStatu:Int {
    case NO_AUDIT = 0  //无需审核
    case AUDIT_WAIT = 1  //待审核
    case AUDIT_THROUGH = 4  //审核通过
    case AUDIT_NOT_PASS = 5 //审核不通过
    case VIEW_END = 6 //查看结束
}


enum ErrorCode:String{
    case  SEC0001 = "SEC0001"   //没有权限
    case  SEC0002 = "SEC0002" //视频查看时间已过期
}
