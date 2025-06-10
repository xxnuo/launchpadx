//
//  ContentView.swift
//  launchpadx
//
//  Created by xxnuo on 2025/6/10.
//

import AppKit
import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isVisible: Bool = false
    @StateObject private var appManager = AppManager()
    @State private var currentPage: Int = 0
    @State private var totalPages: Int = 2
    @FocusState private var isSearchFocused: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false

    private var filteredIcons: [AppIcon] {
        if searchText.isEmpty {
            return appManager.appIcons
        } else {
            return appManager.appIcons.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    private var iconsPerPage: Int {
        // 每页显示7x4=28个图标
        return 28
    }

    private var paginatedIcons: [AppIcon] {
        let startIndex = currentPage * iconsPerPage
        let endIndex = min(startIndex + iconsPerPage, filteredIcons.count)

        if startIndex < filteredIcons.count {
            return Array(filteredIcons[startIndex..<endIndex])
        }
        return []
    }

    var body: some View {
        ZStack {
            // 背景 - 渐变背景
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            // 主内容
            VStack {
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading, 8)

                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .focused($isSearchFocused)

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal, 300)
                .padding(.top, 20)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.1), value: isVisible)

                Spacer()

                // 应用图标网格
                let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 7)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(paginatedIcons) { icon in
                            VStack(spacing: 8) {
                                if let nsImage = icon.nsImage {
                                    // 使用实际应用图标
                                    Image(nsImage: nsImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
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
                    .padding(.horizontal, 60)
                    .padding(.vertical, 30)
                    .offset(x: dragOffset)
                    .animation(
                        isDragging ? nil : .spring(response: 0.3, dampingFraction: 0.8),
                        value: dragOffset
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                isDragging = false
                                let threshold: CGFloat = 100

                                // 向右拖动超过阈值，切换到上一页
                                if value.translation.width > threshold && currentPage > 0 {
                                    currentPage -= 1
                                }
                                // 向左拖动超过阈值，切换到下一页
                                else if value.translation.width < -threshold
                                    && currentPage < totalPages - 1
                                {
                                    currentPage += 1
                                }

                                // 重置偏移量
                                dragOffset = 0
                            }
                    )
                }
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.2), value: isVisible)
                .scaleEffect(isVisible ? 1 : 1.1)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isVisible)

                Spacer()

                // 页面指示器
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { page in
                        Circle()
                            .fill(page == currentPage ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .onTapGesture {
                                withAnimation {
                                    currentPage = page
                                }
                            }
                    }
                }
                .padding(.bottom, 20)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.3), value: isVisible)
            }

            // 左右滑动切换页面的手势区域
            HStack {
                // 左侧区域
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 50)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if currentPage > 0 {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                    }

                Spacer()

                // 右侧区域
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 50)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if currentPage < totalPages - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // 显示动画
            withAnimation {
                isVisible = true
            }

            // 计算总页数
            DispatchQueue.main.async {
                totalPages = max(1, (filteredIcons.count + iconsPerPage - 1) / iconsPerPage)
            }

            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                    window.toggleFullScreen(nil)
                    window.level = .floating  // 使窗口浮在其他应用上面
                    window.collectionBehavior = [.fullScreenPrimary, .canJoinAllSpaces]
                    window.standardWindowButton(.closeButton)?.isHidden = true
                    window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                    window.standardWindowButton(.zoomButton)?.isHidden = true
                    window.isOpaque = false
                    window.backgroundColor = NSColor.clear
                }
            }
        }
        .onChange(of: filteredIcons.count) { newCount in
            // 重新计算总页数
            totalPages = max(1, (newCount + iconsPerPage - 1) / iconsPerPage)
            // 确保当前页面不超出范围
            if currentPage >= totalPages {
                currentPage = max(0, totalPages - 1)
            }
        }
        .onTapGesture { location in
            // 点击屏幕边缘退出应用
            let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 1200, height: 800)
            let edgeThreshold: CGFloat = 50

            if location.x < edgeThreshold || location.x > screenSize.width - edgeThreshold
                || location.y < edgeThreshold || location.y > screenSize.height - edgeThreshold
            {
                NSApplication.shared.terminate(nil)
            }
        }
        .onExitCommand {
            NSApplication.shared.terminate(nil)
        }
        .onAppear {
            // 自动聚焦到搜索框
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isSearchFocused = true
            }
        }
        .keyboardShortcut(
            "f", modifiers: .command,
            action: {
                // 按下Command+F聚焦到搜索框
                isSearchFocused = true
            }
        )
        .keyboardShortcut(
            .leftArrow,
            action: {
                // 左箭头键切换到上一页
                if currentPage > 0 {
                    withAnimation {
                        currentPage -= 1
                    }
                }
            }
        )
        .keyboardShortcut(
            .rightArrow,
            action: {
                // 右箭头键切换到下一页
                if currentPage < totalPages - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                }
            }
        )
        .keyboardShortcut(
            .escape,
            action: {
                // ESC键退出应用
                NSApplication.shared.terminate(nil)
            })
    }
}

// 为View添加键盘快捷键扩展
extension View {
    func keyboardShortcut(
        _ key: KeyEquivalent, modifiers: EventModifiers = .command, action: @escaping () -> Void
    ) -> some View {
        self.background(
            Button("", action: action)
                .keyboardShortcut(key, modifiers: modifiers)
                .opacity(0)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
