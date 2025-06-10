import SwiftUI
import AppKit

struct AppIcon: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: Color
    let appURL: URL?
    let nsImage: NSImage?
    
    init(name: String, iconName: String, color: Color, appURL: URL? = nil, nsImage: NSImage? = nil) {
        self.name = name
        self.iconName = iconName
        self.color = color
        self.appURL = appURL
        self.nsImage = nsImage
    }
    
    static var sampleIcons: [AppIcon] = [
        AppIcon(name: "Safari", iconName: "safari", color: .blue),
        AppIcon(name: "邮件", iconName: "envelope.fill", color: .blue),
        AppIcon(name: "地图", iconName: "map.fill", color: .green),
        AppIcon(name: "信息", iconName: "message.fill", color: .green),
        AppIcon(name: "FaceTime", iconName: "video.fill", color: .green),
        AppIcon(name: "照片", iconName: "photo.fill", color: .pink),
        AppIcon(name: "相机", iconName: "camera.fill", color: .gray),
        AppIcon(name: "日历", iconName: "calendar", color: .red),
        AppIcon(name: "提醒事项", iconName: "list.bullet", color: .orange),
        AppIcon(name: "备忘录", iconName: "note.text", color: .yellow),
        AppIcon(name: "时钟", iconName: "clock.fill", color: .black),
        AppIcon(name: "新闻", iconName: "newspaper.fill", color: .red),
        AppIcon(name: "股市", iconName: "chart.line.uptrend.xyaxis", color: .black),
        AppIcon(name: "天气", iconName: "cloud.sun.fill", color: .blue),
        AppIcon(name: "翻译", iconName: "character.bubble", color: .blue),
        AppIcon(name: "语音备忘录", iconName: "waveform", color: .red),
        AppIcon(name: "计算器", iconName: "plus.slash.minus", color: .orange),
        AppIcon(name: "图书", iconName: "book.fill", color: .orange),
        AppIcon(name: "播客", iconName: "mic.fill", color: .purple),
        AppIcon(name: "App Store", iconName: "a.square.fill", color: .blue),
        AppIcon(name: "设置", iconName: "gearshape.fill", color: .gray)
    ]
} 