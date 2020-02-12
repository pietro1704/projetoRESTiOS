//
//  DateFormatterExtension.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation
extension DateFormatter{
	
	//my dateFormatterExtension for formatting JSON fulliso8601 date
	static let fullISO8601: DateFormatter = {
		let formatter = DateFormatter()
		
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		
		return formatter
	}()
}
