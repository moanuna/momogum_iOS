//
//  SignupEndView.swift
//  momogum
//
//  Created by 서재민 on 2/12/25.
//

import SwiftUI

struct SignupEndView: View {
    @Binding var path: [Route]
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var failed = false

    var body: some View {
        VStack{
            Text("정보 입력 완료!")
                .fontWeight(.semibold)
                .foregroundStyle(.Red_2)
                .font(.system(size: 28))
                .padding(.top,152)
            Text("맛있는 순간을 머머금과 함께해요!")
                .font(.mmg(.subheader3))
                .padding(.top,12)
                .foregroundStyle(.signupStartTextblack)
            Image("SignupStartLogo")
                .resizable()
                .frame(width: 229, height: 229)
                .padding(.top,90)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear { finishLogin() }
        .alert("프로필을 불러오지 못했어요.", isPresented: $failed) {
            Button("다시 시도") { finishLogin() }
            Button("로그인으로 돌아가기") { path = [] }
        }
    }

    private func finishLogin() {
        guard let token = AuthManager.shared.momogumAccessToken else {
            failed = true
            return
        }
        authViewModel.finishLogin(token: token) { failed = !$0 }
    }
}
