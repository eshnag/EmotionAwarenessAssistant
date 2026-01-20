//
//  EmotionService.swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//


import Foundation

final class EmotionService {

    private let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String,
              !key.isEmpty else {
            fatalError("Missing OPENAI_API_KEY")
        }
        return key
    }()

    func analyze(text: String) async -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return "Neutral"
        }

        let prompt = """
        Classify the emotional tone of the following text.

        Choose ONE label from:
        Joy, Sadness, Anger, Fear, Surprise, Disgust, Neutral.

        Respond ONLY with the label.

        Text:
        \(trimmed)
        """

        let requestBody = OpenAIRequest(
            model: "gpt-4o-mini",
            messages: [
                Message(role: "system", content: "You are an emotion classification engine."),
                Message(role: "user", content: prompt)
            ],
            temperature: 0
        )

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return "Neutral"
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(requestBody)

            let (data, response) = try await URLSession.shared.data(for: request)

            // Debug helper 
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                print("OpenAI HTTP status:", http.statusCode)
                print(String(data: data, encoding: .utf8) ?? "")
                return "Neutral"
            }

            let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)

            let rawLabel = decoded.choices.first?.message.content
                .trimmingCharacters(in: .whitespacesAndNewlines)

            return Self.normalizeEmotion(rawLabel)

        } catch {
            print("EmotionService error:", error)
            return "Neutral"
        }
    }

    private static func normalizeEmotion(_ label: String?) -> String {
        switch label?.lowercased() {
        case "joy": return "Joy"
        case "sadness": return "Sadness"
        case "anger": return "Anger"
        case "fear": return "Fear"
        case "surprise": return "Surprise"
        case "disgust": return "Disgust"
        default: return "Neutral"
        }
    }
}
