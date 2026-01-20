//
//  OpenAIRewriteService.swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//

import Foundation

final class OpenAIRewriteService {

    private let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("Missing OPENAI_API_KEY")
        }
        return key
    }()

    private let endpoint = "https://api.openai.com/v1/chat/completions"

    func rewrite(text: String, targetEmotion: String) async -> String {
        let prompt = """
        Rewrite the following text to sound more \(targetEmotion.lowercased()).
        Preserve the original meaning.
        Do not add explanations.

        Text:
        \(text)
        """

        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "You are a helpful writing assistant."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            return decoded.choices.first?.message.content
                .trimmingCharacters(in: .whitespacesAndNewlines)
                ?? text

        } catch {
            print("Rewrite error:", error)
            return text
        }
    }
}
