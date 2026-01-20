//
//  EditorViewModel.swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//

import Foundation

@MainActor
final class EditorViewModel: ObservableObject {

    @Published var text: String = ""
    @Published var emotion: String?
    @Published var confidence: Double?
    @Published var isLoading = false

    private let emotionService = HuggingFaceEmotionService()

    func analyzeEmotion() async {
        isLoading = true
        let result = await emotionService.analyze(text: text)
        self.emotion = result.label
        self.confidence = result.confidence
        isLoading = false
    }
    private let rewriteService = OpenAIRewriteService()

    func rewriteText(to emotion: String) async {
        guard !text.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let rewritten = try await rewriteService.rewrite(
                text: text,
                targetEmotion: emotion
            )
            self.text = rewritten
        } catch {
            print("Rewrite error:", error)
        }
    }


}



