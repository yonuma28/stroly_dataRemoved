//
//  formattedDate.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/20.
//

import Foundation

func formattedDate(from isoDate: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime] // 時間も含めるためのオプション
    if let date = isoFormatter.date(from: isoDate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日HH時mm分" // 日付と時間のフォーマット
        return dateFormatter.string(from: date)
    } else {
        return "日付不明"
    }
}
