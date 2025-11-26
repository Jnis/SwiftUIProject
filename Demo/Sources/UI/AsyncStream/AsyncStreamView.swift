//
//  AsyncStreamView.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

import SwiftUI

struct AsyncStreamView: View {
    
    @EnvironmentObject var env: AppEnvironment
    @StateObject var viewModel: AsyncStreamViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: AsyncStreamViewModel(-1))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("AsyncStream")
            Text("Value: \(viewModel.model.value)")
                .font(.largeTitle)
            HStack {
                Button("Increment") {
                    viewModel.changeValue(viewModel.model.value + 1)
                }
            }
        }
        .padding()
        .background {
            Color.blue.opacity(0.2)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .task {
            await viewModel.inject(service: env.asyncStreamService)
        }
    }
}

#Preview {
    AsyncStreamView()
        .environmentObject(AppEnvironment())
}
