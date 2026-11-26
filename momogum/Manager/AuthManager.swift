//
//  AuthManager.swift
//  momogum
//
//  Created by 서재민 on 2/11/25.
//

import Foundation

final class AuthManager : ObservableObject {
    static let shared = AuthManager()
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: UserProfile? // 유저 정보
    
    private init() {}
    
    private let accessTokenKey = "momogumAccessToken"
    private let KakaoAccessTokenKey = "kakaoAccessToken"
    private let KakaoRefreshTokenKey = "kakaoRefreshToken"
    var UUID: Int? { currentUser?.id }

    //토큰 저장 키체인
    // 카카오소셜토큰값이 들어왔다가 기존 유저의 경우 isNewUser함수 실행하게 되면 해당 토큰값이 서버쪽 토큰값으로 바뀌게 된다.
    // 신규유저의 경우 isNewUser함수 실행시 토큰이 아닌 true값을 받아 회원가입 진행 후 재 로그인 진행하여 토큰값이 소셜토큰값에서 서버토큰값으로 바뀌게된다.
    var momogumAccessToken: String? {
            get {
                return KeychainHelper.shared.get(forKey: accessTokenKey)
            }
            set {
                if let token = newValue {
                    KeychainHelper.shared.save(token, forKey: accessTokenKey)
                } else {
                    KeychainHelper.shared.delete(forKey: accessTokenKey)
                }
            }
        }
    var KakaoAccessToken: String? {
            get {
                return KeychainHelper.shared.get(forKey: KakaoAccessTokenKey)
            }
            set {
                if let token = newValue {
                    KeychainHelper.shared.save(token, forKey: KakaoAccessTokenKey)
                } else {
                    KeychainHelper.shared.delete(forKey: KakaoAccessTokenKey)
                }
            }
        }
    
    var KakaoRefreshToken: String? {
            get {
                return KeychainHelper.shared.get(forKey: KakaoRefreshTokenKey)
            }
            set {
                if let token = newValue {
                    KeychainHelper.shared.save(token, forKey: KakaoRefreshTokenKey)
                } else {
                    KeychainHelper.shared.delete(forKey: KakaoRefreshTokenKey)
                }
            }
        }
    func updateLoginState(isLoggedIn: Bool) {
            DispatchQueue.main.async {
                self.isLoggedIn = isLoggedIn
            }
        }
    
    
    func clearUserData() {
        currentUser = nil
        isLoggedIn = false
        momogumAccessToken = nil
        KakaoAccessToken = nil
        KakaoRefreshToken = nil
    }

    func handleLoginSuccess(userProfile: UserProfile) {
        currentUser = userProfile
        isLoggedIn = true
    }
}
