//
//  GetUUIDModel.swift
//  momogum
//
//  Created by 서재민 on 2/15/25.
//

import Foundation



// MARK: - MyStoryModel
struct GetUUIDResponseModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: UserProfile
}
