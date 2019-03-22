//
//  NSDate+Extension.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/21.
//  Copyright © 2016年 lyx. All rights reserved.
//

import Foundation
enum DateEunm:Int {
    case DateEqual      //等于  date1=date2
    case DateLessThan   //小于  date1 < date2
    case DateMoreThan   //大于  date1 > date2
    case DateError      //传参错误 date1/date2是空
}

public let ALL_Default_Time_form = "yyyy-MM-dd HH:mm:ss"
public let YY_Default_Time_form = "yyyy-MM-dd"
extension Date{
    
    /****将字符串转化为所需要的日期格式****/
    func stringToDate(str:String,format:String) ->Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: str)
        
        return date
    }
    
    /***手机号校验***/
    func isValidateMobile(phoneNumber:String) ->Bool{
        if phoneNumber.characters.count == 0 {
            return false
        }
        let mobile = "^(13|14|15|17|18)[0-9]{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else
        {
            return false
        }
    }
    
    
    /**
     *比较2个日期大小
     *@param date1时间 date2时间 accurate 0精确到秒 1精确到分钟 2精确到小时 3精确到天 4精确到月 5精确到年
     *@return 结果
     */
    func compareDate(date1:Date,date2:Date,accurate:Int) ->DateEunm{
         let calender = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year,.month,.day,.hour,.minute,.second])
        let components1:DateComponents = calender.dateComponents(unitFlags, from: date1)
        let year1 = components1.year      ?? 0
        let month1 = components1.month    ?? 0
        let day1 = components1.day        ?? 0
        let hour1 = components1.hour      ?? 0
        let minute1 = components1.minute  ?? 0
        let second1 = components1.second  ?? 0
        
        let components2:DateComponents = calender.dateComponents(unitFlags, from: date2)
        let year2 = components2.year       ?? 0
        let month2 = components2.month     ?? 0
        let day2 = components2.day         ?? 0
        let hour2 = components2.hour       ?? 0
        let minute2 = components2.minute   ?? 0
        let second2 = components2.second   ?? 0
        
        if (year1 > year2)
        {
            return .DateMoreThan;
        }
        if (year1 < year2)
        {
            return .DateLessThan;
        }
        if (year1 == year2)
        {
            if (accurate == 5)
            {
                return .DateEqual;
            }
            
            if (month1 > month2)
            {
                return .DateMoreThan;
            }
            if (month1 < month2)
            {
                return .DateLessThan;
            }
            if (month1 == month2)
            {
                if (accurate == 4)
                {
                    return .DateEqual;
                }
                
                if (day1 > day2)
                {
                    return .DateMoreThan;
                }
                if (day1 < day2)
                {
                    return .DateLessThan;
                }
                if (day1 == day2)
                {
                    if (accurate == 3)
                    {
                        return .DateEqual;
                    }
                    
                    if (hour1 > hour2)
                    {
                        return .DateMoreThan;
                    }
                    if (hour1 < hour2)
                    {
                        return .DateLessThan;
                    }
                    if (hour1 == hour2)
                    {
                        if (accurate == 2)
                        {
                            return .DateEqual;
                        }
                        
                        if (minute1 > minute2)
                        {
                            return .DateMoreThan;
                        }
                        if (minute1 < minute2)
                        {
                            return .DateLessThan;
                        }
                        if (minute1 == minute2)
                        {
                            if (accurate == 1)
                            {
                                return .DateEqual;
                            }
                            if (second1 > second2)
                            {
                                return .DateMoreThan;
                            }
                            if (second1 < second2)
                            {
                                return .DateLessThan;
                            }
                            if (second1 == second2)
                            {
                                if (accurate == 0)
                                {
                                    return .DateEqual;
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        return.DateError
    }
}
