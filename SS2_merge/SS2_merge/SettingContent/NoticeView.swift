import SwiftUI

struct NoticesView: View {
    let notices: [Notice] = [
        Notice(title: "앱 업데이트 안내", content: "버전 1.2.0 업데이트가 배포되었습니다. 새로운 기능과 개선 사항을 확인하세요.", date: "2024-11-06"),
        Notice(title: "서버 점검 공지", content: "11월 10일 오전 1시부터 3시까지 서버 점검이 예정되어 있습니다. 이 시간 동안 서비스 이용이 제한됩니다.", date: "2024-11-05"),
        Notice(title: "새로운 기능 출시", content: "팀 관리와 캘린더 기능이 추가되었습니다. 업데이트를 통해 새로운 기능을 경험하세요.", date: "2024-11-01")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(notices) { notice in
                        NavigationLink(destination: NoticeDetailView(notice: notice)) {
                            NoticeCardView(notice: notice)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("공지사항")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NoticeCardView: View {
    let notice: Notice

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "megaphone.fill")
                    .foregroundColor(.yellow)
                    .font(.title)
                VStack(alignment: .leading, spacing: 5) {
                    Text(notice.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.top, 5)
                    Text(notice.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            Text(notice.content)
                .font(.body)
                .lineLimit(2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct Notice: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let date: String
}


// 공지사항 세부 내용 뷰
struct NoticeDetailView: View {
    let notice: Notice

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(notice.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .frame(maxWidth: .infinity)
                
                Text(notice.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(notice.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineSpacing(5)
                
                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("공지사항")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NoticesView()
}


