//
//  LyricView.swift
//  Qin (iOS)
//
//  Created by teenloong on 2020/10/12.
//

import SwiftUI

struct LyricView: View {
    @ObservedObject var player: Player = .shared
    @State private var highlightId: Int = 0
    let lyricParser: LyricParser

    init(lyric: String) {
        self.lyricParser = LyricParser(lyric: lyric)
    }

    var body: some View {
        if lyricParser.lyric != "" {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(0..<lyricParser.lyrics.count, id: \.self) { index in
                        Text(lyricParser.lyrics[index])
                            .fontWeight(index == highlightId ? .bold : .none)
                            .foregroundColor(index == highlightId ? .accentColor : .secondTextColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .id(index)
                    }
                }
                .onReceive(player.$loadTime) { newValue in
                    let result = lyricParser.lyricByTime(newValue)
                    
                    highlightId = result.1
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(highlightId, anchor: .center)
                    }

                }
            }
        }else {
            Text("No Lyric")
                .frame(maxHeight: .infinity)
        }
    }
}

#if DEBUG
struct LyricView_Previews: PreviewProvider {
    static var previews: some View {
        //        PlayerView()
        //            .preferredColorScheme(.light)
        //            .environmentObject(Store.shared)
        //            .environmentObject(Player.shared)
        //            .environment(\.managedObjectContext, DataManager.shared.context())
        LyricView(lyric: data)
            .preferredColorScheme(.dark)
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
            .environment(\.managedObjectContext, DataManager.shared.context())
        
    }
}

fileprivate let data: String = """
[ti:夜的第七章]
[ar:周杰伦]
[al:依然范特西]
[by:style海峰]
[00:00.40]周杰伦 - 夜的第七章
[00:03.24]作词：黄俊郎 作曲：周杰伦
[00:06.29]编曲：钟兴民/林迈可
[00:09.79]LRC制作：惜 ゝQQ:727991729
[00:12.85]
[00:42.69]1983年小巷 12月晴朗 夜的第七章
[00:46.42]打字机继续推向 接近事实的那下一行
[00:49.21]石楠烟斗的雾 飘向枯萎的树
[00:52.41]沉默的对我哭诉
[00:54.30]
[00:54.40]贝克街旁的圆形广场
[00:56.35]盔甲骑士臂上 鸢尾花的徽章 微亮
[00:59.72]无人马车声响 深夜的拜访
[01:02.10]邪恶在维多利亚的月光下 血色的开场
[01:05.37]
[01:05.38]消失的手枪 焦黑的手杖
[01:07.25]融化的蜡像 谁不在场
[01:09.13]珠宝箱上 符号的假象
[01:10.81]矛盾通往他堆砌的死巷 证据被完美埋葬
[01:14.02]那嘲弄苏格兰警场的嘴角上扬
[01:16.07]
[01:16.08]如果邪恶 是首华丽残酷的乐章
[01:20.00](那么正义 是深沉无奈的惆怅)
[01:21.47]它的终场 我会 亲手写上
[01:24.92](那我就点亮 在灰烬中的微光)
[01:27.31]晨曦的光 风干最后一行忧伤
[01:31.00](那么雨滴 会洗净黑暗的高墙)
[01:32.94]黑色的墨 染上安详
[01:36.50](散场灯关上 红色的布幕下降)
[01:40.00]
[02:04.54]事实只能穿向 没有脚印的土壤
[02:07.29]突兀的细微花香 刻意显眼的服装
[02:10.12]每个人为不同的理由 戴着面具说谎
[02:12.94]动机也只有一种名字 那叫做欲望
[02:15.74]
[02:15.87]far farther farther far far
[02:17.30]far farther farther far far
[02:18.57]越过人性的沼泽 谁真的可以不被弄脏
[02:21.42]我们可以遗忘 原谅但必须知道真相
[02:24.50]被移动过的铁床 那最后一块图终于拼上
[02:27.04]
[02:27.17]我听见脚步声 预料的软皮鞋跟
[02:29.95]他推开门 晚风晃了 煤油灯一阵
[02:32.74]打字机停在凶手的名称 我转身
[02:36.05]西敏寺的夜空 开始沸腾
[02:38.93]
[02:38.94]在胸口绽放 艳丽的死亡
[02:41.27]我品尝这最后一口 甜美的真相
[02:43.97]微笑回想 正义只是安静的伸张
[02:47.43]提琴在泰晤士
[02:49.03]
[02:49.31]如果邪恶 是首华丽残酷的乐章
[02:54.74]它的终场 我会 亲手写上
[03:06.21]黑色的墨 染上安详
[03:11.67]
[03:11.82]如果邪恶 是首华丽残酷的乐章
[03:17.37]它的终场 我会 亲手写上
[03:22.95]晨曦的光 风干最后一行忧伤
[03:28.63]黑色的墨 染上安详
[03:34.69]
[03:43.03]惜 ゝQQ:727991729
"""
#endif
