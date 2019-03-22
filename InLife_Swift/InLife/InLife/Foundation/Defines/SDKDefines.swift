//
//  SDKDefines.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 lyx. All rights reserved.
//

import Foundation

public let  HOST:String = "http://bsp.ycang.cn/"  //正式环境
//public let  HOST:String = "http://192.168.18.206/" //测试环境
public let  BSP_System:String = HOST + "api/bsp/"
public let  WMS_System:String = HOST + "api/wms/"

//***********************登录********************/
//登录
public let GetCustomerByLoginUrl: String = HOST + "api/common/mobile/login.json"

//选择系统
public let ChooseSystemUrl: String = HOST + "api/common/mobile/selectSystem.json"

//自动登录
public let GetLoginByTokenUrl: String = BSP_System + "loginByToken.json"
//修改密码
public let ChangeInitPwdUrl: String = BSP_System + "user/changeInitPwd.json"

//***********************我的货物********************/
//获取当前商家所有的商品
public let GetAllGoodsListUrl: String = BSP_System + "monitor/getAllGoodsList.json"
//根据仓库、商品查询所有的摄像头
public let GetAllMonitorByGoodUrl: String =  BSP_System + "monitor/getAllMonitorListByWareHouse.json"

//***********************监控********************/
//申请查看监控
public let ApplyLookUpMonitorUrl: String =  BSP_System + "monitor/save.json"
//获取可查看的仓库列表
public let GetWareHouseListUrl: String =  BSP_System + "monitor/getWareHouseListForSelect.json"
//获取申请查看监控列表
public let GetQueryPageForMonitorUrl: String =  BSP_System + "monitor/queryPage.json"
//根据仓库、商品查询所有的摄像头及剩余监控时长
public let GetMonitorTimeLimitUrl: String =  BSP_System + "monitor/getMonitorTimeLimitInfo.json"
//查询摄像头下当前商户的所有商品 (传设备Uuid)
public let GetGoodsListByMonitorUrl: String =  BSP_System + "monitor/getGoodsPageListByMonitor.json"
//倒计时结束后更新后台数据状态
public let UpdateMonitorApplyStatusUrl: String =  BSP_System + "monitor/updateMonitorApplyStatus.json"
//第一次查看视频的时候，去更新后端的view_Time 时间
public let SetMonitorViewTimeUrl: String =  BSP_System + "monitor/setMonitorViewTime.json"


//获取数据字典
public let GetDataConfigurationUrl: String = BSP_System + "dictionary/hikSetting.json"



//***********************WMS********************/

//自动登录
public let GetLoginByTokenOfWMSUrl: String = WMS_System + "loginByToken.json"

//修改密码
public let ChangeWMSPwdUrl: String = WMS_System + "user/changeInitPwd.json"

//选择仓库
public let SelectedWareUrl: String = WMS_System + "selectWarehouse.json"

//获取仓库列表
public let getWareListUrl: String = WMS_System + "getSwitchWarehouseList.json"

//查询进库申请列表
public let GetQueryListUrl: String = WMS_System + "alarmAduit/queryPage.json"

//查询单据号(根据单据类型)
public let GetCodeListByApplyTypeUrl: String = WMS_System + "alarmAduit/getCodeListByApplyType.json"

//新增进库申请
public let AddAlarmAuditUrl: String = WMS_System + "alarmAduit/addAlarmAudit.json"

//申请延时
public let ApplyAlarmDelayUrl: String = WMS_System + "alarmAduit/applyAlarmDelay.json"

//提前布防
public let ProtectInAdvanceUrl: String = WMS_System + "alarmAduit/alarmApplyArmed.json"




//关于我们
public let AboutUsUrl:String = HOST + "mobile/static/about-us.html"
