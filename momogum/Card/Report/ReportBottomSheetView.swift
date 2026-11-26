//
//  ReportBottomsheetView.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct ReportBottomSheet: View {
    @State private var reportFailed = false
    @ObservedObject var viewModel: CardViewModel
    
    let mealDiaryId: Int

    let reasons = [
        ("잘못된 정보", "WRONG_INFO"),
        ("상업적 광고", "COMMERCIAL_ADV"),
        ("음란물", "PORNO"),
        ("폭력성", "VIOLET")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 8)
            
            Text("신고하기")
                .font(.system(size: 18, weight: .semibold))
                .padding(.top, 24)

            Divider()
                .frame(width: 304.5, height: 0.5)
                .background(Color.gray.opacity(0.5))
                .padding(.top, 24)
            
            Text("이 게시물을 신고하는 사유를 선택해주세요.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            Text("신고는 익명으로 처리됩니다.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Divider()
                .frame(width: 304.5, height: 0.5)
                .background(Color.gray.opacity(0.5))
                .padding(.top, 40)

            VStack(spacing: 0) {
                ForEach(reasons, id: \.0) { reasonText, reasonCode in
                    Button(action: {
                        viewModel.reportMealDiary(mealDiaryId: mealDiaryId, reason: reasonCode) {
                            reportFailed = !$0
                        }
                    }) {
                        Text(reasonText)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                            .padding(.leading, 60)
                    }
                    Divider()
                        .frame(width: 304.5, height: 0.5)
                        .background(Color.gray.opacity(0.5))
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .disabled(viewModel.isReporting)
        .interactiveDismissDisabled(viewModel.isReporting)
        .alert("신고하지 못했어요. 다시 시도해 주세요.", isPresented: $reportFailed) {}
    }
}
