//
//  ContentView.swift
//  launchpadx
//
//  Created by xxnuo on 2025/6/10.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            // 背景 - 使用颜色替代模糊背景
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    
                    TextField("搜索", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                }
                .padding(10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal, 50)
                .padding(.top, 20)
                
                // 应用图标网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 30), count: 7), spacing: 30) {
                    ForEach(0..<21) { index in
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(12)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                            }
                            
                            Text("应用 \(index + 1)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                    window.toggleFullScreen(nil)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
