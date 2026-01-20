//
//  HFErrorResponse.swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//

import Foundation
struct HFErrorResponse: Codable {
    let error: String?
    let estimated_time: Double?
}
