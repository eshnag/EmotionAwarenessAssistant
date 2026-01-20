//
//  HuggingFaceEmotionService.swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//

import Foundation

final class HuggingFaceEmotionService {

    private let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["HF_API_KEY"] as? String else {
            fatalError("Missing HF_API_KEY")
        }
        return key
    }()

    private let endpoint =
    "https://router.huggingface.co/hf-inference/models/j-hartmann/emotion-english-distilroberta-base"

    func analyze(text: String) async -> EmotionResult {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return EmotionResult(label: "Neutral", confidence: 1.0)
        }

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONEncoder().encode([
            "inputs": trimmed
        ])
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()

            // Case 1: [[HFEmotionResponse]] -> array of label, scores
            if let batch = try? decoder.decode([[HFEmotionResponse]].self, from: data),
               let predictions = batch.first,
               let top = predictions.max(by: { $0.score < $1.score }) {

                return EmotionResult(
                    label: top.label.capitalized,
                    confidence: top.score
                )
            }

            // Case 2: [HFEmotionResponse]
            if let predictions = try? decoder.decode([HFEmotionResponse].self, from: data),
               let top = predictions.max(by: { $0.score < $1.score }) {

                return EmotionResult(
                    label: top.label.capitalized,
                    confidence: top.score
                )
            }

            // Case 3: error / loading
            if let error = try? decoder.decode(HFErrorResponse.self, from: data) {
                print("HF status:", error)
                return EmotionResult(label: "Neutral", confidence: 0.0)
            }

            print("HF unknown response:", String(data: data, encoding: .utf8) ?? "")
            return EmotionResult(label: "Neutral", confidence: 0.0)

        } catch {
            print("HF decoding error:", error)
            return EmotionResult(label: "Neutral", confidence: 0.0)
        }
    }
}
