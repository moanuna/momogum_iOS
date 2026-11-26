import Foundation
import Alamofire
import FirebaseMessaging

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    
    ///  신규 유저 확인 (API 요청)
    func checkIsNewUser(kakaoLoginModel: KakaoLoginModel, completion: @escaping (Result<IsNewUserResponseModel, APIError>) -> Void) {
          let url = "\(BaseAPI)/auth/login/kakao"
          let headers: HTTPHeaders = ["Content-Type": "application/json", "Cache-Control": "no-cache"]

          AF.request(url, method: .post, parameters: kakaoLoginModel, encoder: JSONParameterEncoder.default, headers: headers)
              .validate()
              .responseDecodable(of: IsNewUserResponseModel.self) { response in
                  switch response.result {
                  case .success(let data):
                      print(" 유저 확인 성공: \(data)")
                      completion(.success(data))

                  case .failure(let error):
                      print(" 유저 확인 실패: \(error.localizedDescription)")
                      if let data = response.data {
                          let responseString = String(data: data, encoding: .utf8)
                          print(" 서버 응답 바디: \(String(describing: responseString))")
                      }
                      completion(.failure(self.handleError(error: error, response: response)))
                  }
              }
    }

    
    func signup(signupModel: SignupModel, completion: @escaping (Result<SignupResponseModel, APIError>) -> Void) {
        Messaging.messaging().token { fcmToken, error in
            if let error = error {
                completion(.failure(.networkError))
//                print("❌ FCM 토큰 가져오기 실패: \(error.localizedDescription)")
                return
            }
            
            guard let fcmToken = fcmToken else {
                completion(.failure(.networkError))
                return
            }
        
        var parameters = [
                  "accessToken": signupModel.accessToken,
                  "name": signupModel.name,
                  "nickname": signupModel.nickname
              ]
              
              parameters["fcmToken"] = fcmToken
            let url = "\(BaseAPI)/auth/signup/kakao" // 백엔드에서 정의한 회원가입 엔드포인트
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]

            AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .responseDecodable(of: SignupResponseModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        print(" 회원가입 성공")
                        print(" isSuccess: \(data.isSuccess)")
                        print(" message: \(data.message)")
                        completion(.success(data))
                        
                    case .failure(let error):
                        print("회원가입 실패")
                        print(" error: \(error.localizedDescription)")
                        if let data = response.data {
                            let responseString = String(data: data, encoding: .utf8)
                            print(" 응답 바디: \(String(describing: responseString))")
                        }
                        completion(.failure(self.handleError(error: error, response: response)))
                    }
                    }
                }
        }
    
    
    func checkDuplicateUsername(username: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
        let url = "\(BaseAPI)/auth/check-nickname?nickname=\(username)"
           let headers: HTTPHeaders = ["Content-Type": "application/json", "Cache-Control": "no-cache"]
        
           AF.request(url, method: .get, headers: headers)
               .validate()
               .responseDecodable(of: IsDuplicatedResponseModel.self) { response in
                   switch response.result {
                   case .success(let data):
                       print(" 아이디 중복 확인 성공")
                       
                       print("url: \(url)")
                       print("isSuccess: \(data.isSuccess), 중복 여부: \(data.result)")
                       completion(.success(data.result)) // `true`이면 중복, `false`이면 사용 가능

                   case .failure(let error):
                       print(" 아이디 중복 확인 실패")
                       print("error: \(error.localizedDescription)")
                       if let data = response.data {
                           let responseString = String(data: data, encoding: .utf8)
                           print(" 응답 바디: \(String(describing: responseString))")
                           print("url: \(url)")
                       }
                       completion(.failure(self.handleError(error: error, response: response)))
                   }
               }
       }
    
    func fetchUUID(token : String, completion: @escaping(Result<GetUUIDResponseModel, APIError>)-> Void){
        let url = "\(BaseAPI)/auth/me"
        let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        print("url : \(url)")
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GetUUIDResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    print("PK값 통신 성공")
                    completion(.success(data))
                case .failure(let error):
                    print("PK값 통신실패")
                    print(error)
                    completion(.failure(self.handleError(error: error, response: response)))

                }
            }
    }
    
    
    ///  에러 핸들링 로직
    private func handleError<T>(error: AFError, response: DataResponse<T, AFError>) -> APIError {
          if let statusCode = response.response?.statusCode {
              return APIError.httpError(statusCode)
          }
          return APIError.networkError
      }
  }

enum APIError: Error {
    case httpError(Int)
    case networkError
    case decodingError
}
