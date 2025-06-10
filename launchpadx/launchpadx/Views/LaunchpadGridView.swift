import SwiftUI

struct LaunchpadGridView: View {
    let columns: Int
    let spacing: CGFloat
    let icons: [AppIcon]
    
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0
    
    private var iconSize: CGFloat {
        // 动态计算图标大小，基于屏幕宽度和列数
        let screenWidth = NSScreen.main?.frame.width ?? 1200
        let availableWidth = screenWidth - (spacing * CGFloat(columns + 1))
        return availableWidth / CGFloat(columns)
    }
    
    private var rows: Int {
        // 动态计算行数，基于屏幕高度
        let screenHeight = NSScreen.main?.frame.height ?? 800
        let availableHeight = screenHeight * 0.7 // 使用屏幕高度的70%
        let rowHeight = iconSize + spacing + 20 // 图标高度 + 间距 + 文本高度
        return Int(availableHeight / rowHeight)
    }
    
    private var iconsPerPage: Int {
        columns * rows
    }
    
    private var pageCount: Int {
        Int(ceil(Double(icons.count) / Double(iconsPerPage)))
    }
    
    private func getPageIcons(_ page: Int) -> [AppIcon] {
        let startIndex = page * iconsPerPage
        let endIndex = min(startIndex + iconsPerPage, icons.count)
        if startIndex < icons.count {
            return Array(icons[startIndex..<endIndex])
        }
        return []
    }
    
    var body: some View {
        VStack {
            // 主网格视图
            TabView(selection: $currentPage) {
                ForEach(0..<pageCount, id: \.self) { page in
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns), spacing: spacing) {
                        ForEach(getPageIcons(page)) { icon in
                            AppIconView(appIcon: icon, size: iconSize * 0.8)
                                .padding(.vertical, 5)
                        }
                    }
                    .padding(.horizontal, spacing)
                    .tag(page)
                }
            }
            .tabViewStyle(.automatic)
            .background(Color.black.opacity(0.01)) // 几乎透明的背景，用于捕获手势
            
            // 页面指示器
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { page in
                    Circle()
                        .fill(currentPage == page ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        LaunchpadGridView(columns: 7, spacing: 20, icons: AppIcon.sampleIcons)
    }
} 