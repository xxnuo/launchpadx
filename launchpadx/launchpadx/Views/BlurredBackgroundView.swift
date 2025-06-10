import SwiftUI
import AppKit

struct BlurredBackgroundView: View {
    var body: some View {
        ZStack {
            // 使用当前桌面壁纸作为背景
            if let screen = NSScreen.main {
                if let wallpaper = NSWorkspace.shared.desktopImageURL(for: screen),
                   let nsImage = NSImage(contentsOf: wallpaper) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 20)
                }
            }
            
            // 添加一个暗色覆盖层，增强视觉效果
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    BlurredBackgroundView()
} 