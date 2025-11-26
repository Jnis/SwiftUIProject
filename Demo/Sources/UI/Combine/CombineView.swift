//
//  CombineView.swift
//  Demo
//
//  Created by Yanis Plumit on 23.11.2025.
//

import SwiftUI

struct CombineView: View {
    
    @EnvironmentObject var env: AppEnvironment
    @StateObject var viewModel: CombineViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: CombineViewModel(-1))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Combine")
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
            Color.red.opacity(0.2)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .task {
            viewModel.inject(service: env.combineService)
        }
    }
}

#Preview {
    CombineView()
        .environmentObject(AppEnvironment())
}
