//
//  OpenAIModels.swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//

import Foundation
struct OpenAIChoice: Codable {
    let message: OpenAIMessage
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
}

struct Message: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}
struct OpenAIResponsesRequest: Codable {
    let model: String
    let input: String
}

struct Choice: Codable {
    let message: Message
}
struct OpenAIResponsesResponse: Codable {
    let output: [Output]?
    let output_text: String?
}

struct Output: Codable {
    let content: [OutputContent]
}

struct OutputContent: Codable {
    let type: String
    let text: String?
}
