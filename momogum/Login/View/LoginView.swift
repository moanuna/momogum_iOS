//
//  SwiftUIView.swift
//  momogum
//
//  Created by 서재민 on 1/11/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(SignupDataModel.self) var signupDataModel
    @FocusState private var isFocused: Bool // TextField의 포커스 상태
    @FocusState private var isFocusedPWD: Bool
    @State private var loginFailed = false
    @State private var path: [Route] = [] //path 설정
    var body: some View {
        
        NavigationStack(path: $path){
            let authViewModel = AuthViewModel(signupData: signupDataModel) 

            Text("머머금과 함께 밥일기를 공유하고, 식사고민을 해결해요!")
                .font(.mmg(.subheader1))
                .foregroundStyle(.momogumRed)
                .padding(.top, 127)
                .padding(.leading, 46)
                .padding(.trailing, 22)
            
            
            Image("Momogum")
                .resizable()
                .frame(width: 160, height: 160)
                .padding(.horizontal,116)
                .padding(.top, 72)
                .padding(.bottom, 61)
            
            
            Button{
                    authViewModel.handleKakaoLogin { success in
                        if success {
                            authViewModel.checkIsNewUser { success, isNew in
                                if success && isNew { path.append(.SignupStartView) }
                                loginFailed = !success
                            }
                        } else {
                            loginFailed = true
                        }
                    }
            }
                label: {
                    Image("KakaoLogin")
                }
                
                .alert("로그인에 실패했어요. 다시 시도해 주세요.", isPresented: $loginFailed) {}
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case.SignupStartView:
                        SignupStartView(path: $path)
                        
                    case.SignupStep1View:
                        SignupStep1View(authViewModel: authViewModel, path: $path)
                        
                    case.SignupStep2View:
                        SignupStep2View(authViewModel: authViewModel, path: $path)
                    case.SignupEndView:
                        SignupEndView(path: $path, authViewModel: authViewModel)
                    }
                    
                }
                

                Button{
                    
                }
                label: {
                    Image("appleSignin")
                        .resizable()
                        .frame(width: 300 ,height: 45)
                }
                
                Spacer()
            }
        }
        
        
    }


#Preview {
    LoginView()
}
