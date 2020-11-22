//
//  CommentView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/21.
//

import SwiftUI

struct CommentView: View {
    let id: Int64
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    NEUNavigationBarTitleView("歌曲评论")
                    Spacer()
                    Button(action: {}) {
                        NEUSFView(systemName: "ellipsis" , size:  .medium)
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)
                CommentListView(id: id)
            }
        }
    }
}

#if DEBUG
struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(id: 0)
            .environmentObject(Store.shared)
    }
}
#endif

struct CommentListView: View {
    @EnvironmentObject private var store: Store
    private var comment: AppState.Comment { store.appState.comment }
    @State private var editComment: String = ""
    @State private var showCancel: Bool = false
    let id: Int64
    
    var body: some View {
        VStack {
            HStack {
                TextField("编辑评论", text: $editComment)
                    .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "text.bubble", size: .small)))
                if showCancel {
                    Button(action: {
                        hideKeyboard()
                    }, label: {
                        Text("取消")
                    })
                }
                Button(action: {
                    hideKeyboard()
                    Store.shared.dispatch(.comment(id: id, content: editComment, type: .song, action: .add))
                    editComment = ""
                }) {
                    NEUSFView(systemName: "arrow.up.message.fill", size: .small)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
            }
            .padding(.horizontal)
            .onAppear {
                Store.shared.dispatch(.commentMusic(id: id))
            }
            if comment.commentMusicRequesting {
                Text("正在加载...")
                    .foregroundColor(.mainTextColor)
                Spacer()
            }else {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("热门评论(\(String(comment.hotComments.count)))")
                                .foregroundColor(.mainTextColor)
                            Spacer()
                        }
                        ForEach(comment.hotComments) { item in
                            CommentRowView(viewModel: item, id: id, type: .song)
                            Divider()
                        }
                        HStack {
                            Text("最新评论(\(String(comment.total)))")
                                .foregroundColor(.mainTextColor)
                            Spacer()
                        }
                        ForEach(comment.comments) { item in
                            CommentRowView(viewModel: item, id: id, type: .song)
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                    if comment.comments.count < comment.total {
                        Button(action: {
                            Store.shared.dispatch(.commentMusicLoadMore)
                        }, label: {
                            Text("加载更多")
                        })
                    }
                    Spacer()
                        .frame(height: 20)
                }
            }
        }
    }
}

struct CommentRowView: View {
    @EnvironmentObject var store: Store
    private var user: User? { store.appState.settings.loginUser }

    @StateObject var viewModel: CommentViewModel
    let id: Int64
    let type: NeteaseCloudMusicApi.CommentType
    
    @State var showBeReplied = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            NEUCoverView(url: viewModel.avatarUrl, coverShape: .rectangle, size: .little)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(viewModel.nickname)
                    Spacer()
                    Text(String(viewModel.likedCount))
                    Button(action: {
                        Store.shared.dispatch(.commentLike(id: id, cid:viewModel.commentId, like: viewModel.liked ? false : true, type: type))
                        viewModel.liked.toggle()
                    }, label: {
                        Image(systemName: viewModel.liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                    })
                }
                .foregroundColor(.secondTextColor)
                Text(viewModel.content)
                    .foregroundColor(.mainTextColor)
                HStack {
                    if viewModel.beReplied.count > 0 {
                        Button(action: {
                            showBeReplied.toggle()
                        }, label: {
                            HStack(spacing: 0.0) {
                                Text("\(viewModel.beReplied.count)条回复")
                                Image(systemName: showBeReplied ? "chevron.down" : "chevron.up")
                            }
                        })
                    }
                    Spacer()
                    if viewModel.userId == user?.uid {
                        Button(action: {
                            Store.shared.dispatch(.comment(id: id, cid: viewModel.commentId, type: type, action: .delete))
                        }, label: {
                            Text("删除")
                        })
                    }
                }
                if showBeReplied {
                    ForEach(viewModel.beReplied) { item in
                        CommentRowView(viewModel: item, id: id, type: type)
                    }
                }
            }
        }
    }
}
