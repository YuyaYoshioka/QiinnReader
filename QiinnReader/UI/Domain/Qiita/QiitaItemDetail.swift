//
//  QiitaItemDetail.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/21.
//

import SwiftUI
import MarkdownView

struct QiitaItemDetail: View {
    @State var item: QiitaItem

    var body: some View {
        ScrollView {
            HStack {
                AsyncImage(url: URL(string: item.user.profileImageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.crop.circle").resizable()
                }
                .clipShape(Circle())
                .frame(width: 30, height: 30)
                Text("@\(item.user.id)")
                Spacer()
            }
            HStack {
                Text("投稿日")
                Text(CustomDateFormatter.createDateStrFromISO8601DateString(iSO8601DateString:  item.createdAt))
                    .padding(.trailing)
                Text("更新日")
                Text(CustomDateFormatter.createDateStrFromISO8601DateString(iSO8601DateString:  item.updatedAt))
                Spacer()
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.bottom)
            HStack {
                Text(item.title)
                    .font(.title)
                Spacer()
            }
            .padding(.bottom)
            HStack(alignment: .top) {
                Image(systemName: "tag.fill")
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(270))
                Text(item.createTagNames())
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.footnote)
                Spacer()
            }
            .padding(.bottom, 64)
            Markdown(markdown: item.body)
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QiitaItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        QiitaItemDetail(item: QiitaModelExamples.createQiitaItemFactory())
    }
}

struct Markdown: UIViewRepresentable {
    let markdown: String

    func makeUIView(context: Context) -> MarkdownView {
        let md = MarkdownView()
        md.load(markdown: markdown)
        
        md.onTouchLink = { request in
            guard let url = request.url else { return false }
            guard url.scheme == "https" else { return false }
            UIApplication.shared.open(url)
            
            return false
        }
        
        return md
    }
    
    func updateUIView(_ uiView: MarkdownView, context: Context) {
    }
}
