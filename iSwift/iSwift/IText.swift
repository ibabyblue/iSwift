//
//  IText.swift
//  iSwift
//
//  Created by ibabyblue on 2024/5/16.
//

import SwiftUI

struct IText: View {
    var body: some View {
        let manyString = "这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。这是一段长文。结尾啦"
        ScrollView {
            //垂直方向布局
            VStack(alignment: .leading) {
                
                Text("Hello, World!")
                    .background(Color.green)
                Text("Title")
                    .font(.largeTitle)
                    .background(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                //水平方向布局
                HStack(alignment: VerticalAlignment.top, spacing: 0) {
                    Text("first")
                        .font(.largeTitle)
                        .background(Color.purple)
                    Text("second")
                        .font(.largeTitle)
                        .background(Color.gray)
                }
                
                Text("系统字体")
                    .font(.system(.title))
                Text("系统字体")
                    .font(.system(.title2))
                Text("系统字体")
                    .font(.system(.title3))
                Text("系统字体")
                    .font(.system(.headline))
                Text("系统字体")
                    .font(.system(.subheadline))
                Text("系统字体")
                    .font(.system(.body))
                Text("系统字体")
                    .font(.system(.callout))
                Text("系统字体")
                    .font(.system(.footnote))
                Text("系统字体")
                    .font(.system(.caption))
                Text("系统字体")
                    .font(.system(.caption2))
                
                Text("字重-加粗")
                    .fontWeight(Font.Weight.heavy)//加粗
                Text("字重-纤细")
                    .fontWeight(Font.Weight.ultraLight)//纤细
                
                Text("自定义字体")
                      .font(Font.custom("PingFangSC-Regular", fixedSize: 20))
                
                Text("字体颜色")
                    .foregroundStyle(.blue)
                
                Text("旋转的文字")
                    .rotationEffect(.degrees(45))
                    .fixedSize()
                    .frame(width: 20, height: 80)
                    .padding(.leading, 25)
                
                Text("划重点")
                    .underline()
                    .foregroundColor(.yellow)
                    .fontWeight(.heavy)
                
                Text("有阴影")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                    .bold()
                    .shadow(color: .black, radius: 1, x: 0, y: 2)
                
                //!!!: 中文设置斜体无效
                Text("italic")
                    .italic()
                
                Text("模糊")
                    .blur(radius: 1)
                
                Text("删除线")
                    .strikethrough()
                
                Text("垂直方向上的基线偏移")
                    .baselineOffset(10.0)
                    .background(Color.red)
                
                Text("垂直方向上的基线未偏移")
                    .background(Color.red)
                
                Text("内边距")
                .padding(20)
                .background(Color.black)
                .foregroundColor(.white)//调用的顺序由上而下进行
                .font(.largeTitle)//设置文字内容的样式为巨型标题
                .padding(15)//设置填充属性的值为15增加文本视图与文字内容的间距
                .background(Color.yellow)//背景颜色为黄色
                .padding(15)//在文本视图的外围再次增加15点的间距
                .background(Color.orange)//给新的内边距设置填充颜色为橙色
                .padding(10)//在外围增加十点间距
                
                Text("间距文案- kerning")
                    .kerning(5)//字符对间距
                Text("间距文案 - tracking")
                    .tracking(5)//全局字符间距
                
                //垫片-透明（设置颜色无效）、可设置长度的空白空间
                Spacer(minLength: 20)
                
                Text(manyString)
                    .lineLimit(3)
                    .lineSpacing(10.0)
                    .multilineTextAlignment(.leading)
                
                //使用fixedSize可以在任何时候完整显示
                Text(manyString)
                    .fixedSize(horizontal: false, vertical: true)
                
                //垫片-透明（设置颜色无效）、可设置长度的空白空间
                Spacer(minLength: 20)
                
                Text("带背景图片的")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .background {
                        Rectangle()
                            .fill(.blue)
                            .cornerRadius(10)
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    .frame(width: 200, height: 100)
                
                //文字渐变
                Text("Gradient foreground")
                    .font(.largeTitle)
                    .padding()
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .green, .blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                
                //文字背景渐变-上~下
                Text("Gradient Background")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .black, .red]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(10)
                
                //文字背景渐变-左~右
                Text("Gradient Background")
                    .padding(5)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .black, .purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                
                //z轴方向布局
                ZStack {
                    Text("渐变透明材质风格")
                        .padding()
                        .background(
                            .regularMaterial,
                            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                        )
                        .shadow(radius: 10)
                        .padding()
                        .font(.largeTitle.weight(.black))
                }
                .frame(width: 300, height: 200)
                .background(
                    LinearGradient(colors: [.yellow, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                
                //角度渐变
                Text("Angular Gradient Background")
                    .padding()
                    .background(AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center))
                    .cornerRadius(20)
                
                
                // 使用 AttributeString
                PTextViewAttribute()
                    .padding()
                
//                // 使用 Markdown
//                PTextViewMarkdown()
//                    .padding()

                // 时间
                PTextViewDate()

                // 插值
                PTextViewInterpolation()
                
            }
            .padding()
        }
//        .edgesIgnoringSafeArea(.all)//忽略安全区域，默认不忽略（限制在刘海下方）
        
    }
}

// MARK: - Markdown
struct PTextViewMarkdown: View {
    let mdaStr: AttributedString = {
        
        var mda = AttributedString(localized: "这是一个 **Attribute** ~string~")
        
        /// 自定义的属性语法是^[string](key：value)
        mda = AttributedString(localized: "^[这是](p2:'one')^[一](p3:{k1:1,k2:2})个 **Attribute** ~string~", including: \.newScope)
        print(mda)
        /// 这是 {
        ///     NSLanguage = en
        ///     p2 = one
        /// }
        /// 一 {
        ///     NSLanguage = en
        ///     p3 = P3(k1: 1, k2: 2)
        /// }
        /// 个  {
        ///     NSLanguage = en
        /// }
        /// Attribute {
        ///     NSLanguage = en
        ///     NSInlinePresentationIntent = NSInlinePresentationIntent(rawValue: 2)
        /// }
        ///   {
        ///     NSLanguage = en
        /// }
        /// string {
        ///     NSInlinePresentationIntent = NSInlinePresentationIntent(rawValue: 32)
        ///     NSLanguage = en
        /// }
        
        // 从文件中读取 Markdown 内容
        let mdUrl = Bundle.main.url(forResource: "1", withExtension: "md")!
        mda = try! AttributedString(contentsOf: mdUrl,options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace), baseURL: nil) // .inlineOnlyPreservingWhitespace 支持 markdown 文件的换行
                
        // Markdown 已转换成 AtrributedString 结构。
        for r in mda.runs {
            if let ipi = r.inlinePresentationIntent {
                switch ipi {
                case .lineBreak:
                    print("paragrahp")
                case .code:
                    print("this is code")
                default:
                    break
                }
            }
            if let pi = r.presentationIntent {
                for c in pi.components {
                    switch c.kind {
                    case .paragraph:
                        print("this is paragraph")
                    case .codeBlock(let lang):
                        print("this is \(lang ?? "") code")
                    case .header(let level):
                        print("this is \(level) level")
                    default:
                        break
                    }
                }
            }
        }
        
        return mda
    }()
    var body: some View {
        Text(mdaStr)
    }
}

// MARK: - 插值
struct PTextViewInterpolation: View {
    let nf: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currencyPlural
        return f
    }()
    var body: some View {
        VStack {
            Text("图文 \(Image(systemName: "sun.min"))")
            Text("💰 \(999 as NSNumber, formatter: nf)")
                .environment(\.locale, Locale(identifier: "zh_cn"))
            Text("数组： \(["one", "two"])")
            Text("红字：\(red: "变红了")，带图标的字：\(sun: "天晴")")
        }
    }
}

// 扩展 LocalizedStringKey.StringInterpolation 自定义插值
extension LocalizedStringKey.StringInterpolation {
    // 特定类型处理
    mutating func appendInterpolation(_ value: [String]) {
        for s in value {
            appendLiteral(s + "")
            appendInterpolation(Text(s + " ").bold().foregroundColor(.secondary))
        }
    }
    
    // 实现不同情况处理，可以简化设置修改器设置
    mutating func appendInterpolation(red value: LocalizedStringKey) {
        appendInterpolation(Text(value).bold().foregroundColor(.red))
    }
    mutating func appendInterpolation(sun value: String) {
        appendInterpolation(Image(systemName: "sun.max.fill"))
        appendLiteral(value)
    }
}

// MARK: - 时间
struct PTextViewDate: View {
    let date: Date = Date()
    let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        return df
    }()
    var dv: String {
        return df.string(from: date)
    }
    var body: some View {
        HStack {
            Text(dv)
        }
        .environment(\.locale, Locale(identifier: "zh_cn"))
    }
}

//
struct PTextViewAttribute: View {
    let aStr: AttributedString = {
        var a1 = AttributedString("这是一个 ")
        var c1 = AttributeContainer()
        c1.font = .footnote
        c1.foregroundColor = .secondary
        a1.setAttributes(c1)
        
        var a2 = AttributedString("Attribute ")
        var c2 = AttributeContainer()
        c2.font = .title
        a2.setAttributes(c2)
        
        var a3 = AttributedString("String ")
        var c3 = AttributeContainer()
        c3.baselineOffset = 10
//        c3.appKit.foregroundColor = .yellow // 仅在 macOS 里显示的颜色
        c3.swiftUI.foregroundColor = .secondary
        c3.font = .footnote
        a3.setAttributes(c3)
        // a3 使用自定义属性
        a3.p1 = "This is a custom property."
        
        // formatter 的支持
        var a4 = Date.now.formatted(.dateTime
                                        .hour()
                                        .minute()
                                        .weekday()
                                        .attributed
        )
        
        let c4AMPM = AttributeContainer().dateField(.amPM)
        let c4AMPMColor = AttributeContainer().foregroundColor(.green)
        
        a4.replaceAttributes(c4AMPM, with: c4AMPMColor)
        let c4Week = AttributeContainer().dateField(.weekday)
        let c4WeekColor = AttributeContainer().foregroundColor(.purple)
        a4.replaceAttributes(c4Week, with: c4WeekColor)
        
        a1.append(a2)
        a1.append(a3)
        a1.append(a4)
        
        // Runs 视图
        for r in a1.runs {
            print(r)
        }
        /// 这是一个  {
        ///     SwiftUI.Font = Font(provider: SwiftUI.(unknown context at $7ff91d4a5e90).FontBox<SwiftUI.Font.(unknown context at $7ff91d4ad5d8).TextStyleProvider>)
        ///     SwiftUI.ForegroundColor = secondary
        /// }
        /// Attribute  {
        ///     SwiftUI.Font = Font(provider: SwiftUI.(unknown context at $7ff91d4a5e90).FontBox<SwiftUI.Font.(unknown context at $7ff91d4ad5d8).TextStyleProvider>)
        /// }
        /// String  {
        ///     SwiftUI.ForegroundColor = secondary
        ///     SwiftUI.BaselineOffset = 10.0
        ///     NSColor = sRGB IEC61966-2.1 colorspace 1 1 0 1
        ///     SwiftUI.Font = Font(provider: SwiftUI.(unknown context at $7ff91d4a5e90).FontBox<SwiftUI.Font.(unknown context at $7ff91d4ad5d8).TextStyleProvider>)
        ///     p1 = This is a custom property.
        /// }
        /// Tue {
        ///     SwiftUI.ForegroundColor = purple
        /// }
        ///   {
        /// }
        /// 5 {
        ///     Foundation.DateFormatField = hour
        /// }
        /// : {
        /// }
        /// 16 {
        ///     Foundation.DateFormatField = minute
        /// }
        ///   {
        /// }
        /// PM {
        ///     SwiftUI.ForegroundColor = green
        /// }
        
        return a1
    }()
    var body: some View {
        Text(aStr)
    }
}

// MARK: - 自定 AttributedString 属性
struct PAKP1: AttributedStringKey {
    typealias Value = String
    static var name: String = "p1"
    
    
}
struct PAKP2: CodableAttributedStringKey, MarkdownDecodableAttributedStringKey {
    public enum P2: String, Codable {
        case one, two, three
    }

    static var name: String = "p2"
    typealias Value = P2
}
struct PAKP3: CodableAttributedStringKey, MarkdownDecodableAttributedStringKey {
    public struct P3: Codable, Hashable {
        let k1: Int
        let k2: Int
    }
    typealias Value = P3
    static var name: String = "p3"
}
extension AttributeScopes {
    public struct NewScope: AttributeScope {
        let p1: PAKP1
        let p2: PAKP2
        let p3: PAKP3
    }
    var newScope: NewScope.Type {
        NewScope.self
    }
}

extension AttributeDynamicLookup{
    subscript<T>(dynamicMember keyPath:KeyPath<AttributeScopes.NewScope,T>) -> T where T:AttributedStringKey {
        self[T.self]
    }
}

#Preview {
    IText()
}
