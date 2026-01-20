//
//  EditorView.swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//

//
//  EditorView.Swift
//  Emotion Aware Writing Assistant
//
//  Created by Eshna Gupta on 1/19/26.
//


import SwiftUI

struct EditorView: View {

    @StateObject private var viewModel = EditorViewModel()

    private func emotionColor(_ emotion: String) -> Color {
        switch emotion {
        case "Joy": return .green
        case "Sadness": return .blue
        case "Anger": return .red
        case "Fear": return .purple
        case "Surprise": return .orange
        case "Disgust": return .brown
        default: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 20) {

            Text("Emotion-Aware Writing")
                .font(.title)
                .bold()

            TextEditor(text: $viewModel.text)
                .frame(height: 200)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3))
                )

            Button {
                Task {
                    await viewModel.analyzeEmotion()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Analyze Emotion")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)

            Spacer()

       
            if let emotion = viewModel.emotion {
                Text("Emotion: \(emotion)")
                    .font(.title3)
                    .foregroundColor(emotionColor(emotion))

                if let confidence = viewModel.confidence {
                    Text("Confidence: \(Int(confidence * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Button("Make Happier") {
                        Task { await viewModel.rewriteText(to: "happy") }
                    }

                    Button("Make Calmer") {
                        Task { await viewModel.rewriteText(to: "calm") }
                    }

                    Button("More Confident") {
                        Task { await viewModel.rewriteText(to: "confident") }
                    }
                }
                .buttonStyle(.bordered)
            }


        }
        .padding()
        .animation(.easeInOut, value: viewModel.emotion)
    }
}


#Preview {
    EditorView()
}
