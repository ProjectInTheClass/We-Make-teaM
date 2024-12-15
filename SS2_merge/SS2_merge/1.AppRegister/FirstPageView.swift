//앱 접속시 첫 페이지
import SwiftUI

struct FirstPageView: View {
    var body: some View {
        ZStack{
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()
            VStack(){
                Spacer()
                Spacer()
                Image("logo2")
                    .resizable()
                    .frame(width:200, height:200)
                Image("name1")
                    .resizable()
                    .frame(width:300, height:120)
                Text("모두가 참여하는 프로젝트 관리 앱")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .offset(y:-20)
                Spacer()
                Spacer()
            }
            
        }
    }
}

#Preview{
    FirstPageView()
}
