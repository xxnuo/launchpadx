//
//  ContentView.swift
//  launchpadx
//
//  Created by xxnuo on 2025/6/10.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isVisible: Bool = false
    @StateObject private var appManager = AppManager()
    
    private var filteredIcons: [AppIcon] {
        if searchText.isEmpty {
            return appManager.appIcons
        } else {
            return appManager.appIcons.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        ZStack {
            // 背景 - 使用颜色替代模糊背景
            Color.black.edgesIgnoringSafeArea(.all)
            
            // 主内容
            VStack {
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("搜索", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal, 50)
                .padding(.top, 20)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.1), value: isVisible)
                
                // 应用图标网格
                let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 7)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredIcons) { icon in
                            VStack(spacing: 5) {
                                ZStack {
                                    if let nsImage = icon.nsImage {
                                        // 使用实际应用图标
                                        Image(nsImage: nsImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                    } else {
                                        // 使用系统图标和背景色作为备用
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(icon.color)
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: icon.iconName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(12)
                                            .foregroundColor(.white)
                                            .frame(width: 60, height: 60)
                                    }
                                }
                                
                                Text(icon.name)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            .onTapGesture {
                                if let appURL = icon.appURL {
                                    NSWorkspace.shared.open(appURL)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.2), value: isVisible)
                .scaleEffect(isVisible ? 1 : 1.1)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isVisible)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // 显示动画
            withAnimation {
                isVisible = true
            }
            
            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                    window.toggleFullScreen(nil)
                    window.level = .floating // 使窗口浮在其他应用上面
                    window.collectionBehavior = [.fullScreenPrimary, .canJoinAllSpaces]
                    window.standardWindowButton(.closeButton)?.isHidden = true
                    window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                    window.standardWindowButton(.zoomButton)?.isHidden = true
                    window.isOpaque = false
                    window.backgroundColor = NSColor.clear
                }
            }
        }
        .onTapGesture { location in
            // 点击屏幕边缘退出应用
            let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1200, height: 800)
            let edgeThreshold: CGFloat = 50
            
            if location.x < edgeThreshold || location.x > screenSize.width - edgeThreshold ||
               location.y < edgeThreshold || location.y > screenSize.height - edgeThreshold {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

#Preview {
    ContentView()
}
