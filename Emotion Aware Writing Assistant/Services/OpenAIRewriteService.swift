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

    private let endpoint = "https://api.openai.com/v1/responses"

    func rewrite(text: String, targetEmotion: String) async throws -> String {

        let body = OpenAIResponsesRequest(
            model: "gpt-4o-mini",
            input: """
            Rewrite the following text so that it clearly conveys the emotion: \(targetEmotion).

            Keep the meaning the same, but adjust tone, wording, and style.

            Text:
            \(text)
            """
        )

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            print("OpenAI HTTP:", http.statusCode)
            print(String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(OpenAIResponsesResponse.self, from: data)

        if let directText = decoded.output_text {
            return directText
        }

        if let output = decoded.output {
            return output
                .flatMap { $0.content }
                .first(where: { $0.type == "output_text" })?
                .text ?? text
        }

        return text
    }



}
