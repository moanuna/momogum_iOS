//
//  HeartView.swift
//  momogum
//
//  Created by 조승연 on 2/3/25.
//

import SwiftUI

struct HeartView: View {
    @ObservedObject var viewModel: CardViewModel
    var mealDiaryId: Int
    @State private var showHeartBottomSheet = false

    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleLikeAPI(mealDiaryId: mealDiaryId)
            }) {
                Image(viewModel.card.isLiked ? "heart_fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .disabled(viewModel.isUpdatingLike)
            .onTapGesture {
                showHeartBottomSheet = true
            }

            Spacer().frame(width: 12)

            Text(viewModel.card.likeCount >= 99 ? "99+" : "\(viewModel.card.likeCount)")
                .font(.system(size: 16))
                .opacity(viewModel.card.likeCount > 0 ? 1 : 0)
        }
        .sheet(isPresented: $viewModel.showHeartBottomSheet) {
            HeartBottomSheetView(viewModel: viewModel, mealDiaryId: mealDiaryId)
                .presentationDetents([.fraction(2/3)])
                .onAppear {
                    viewModel.fetchLikedUsers(mealDiaryId: mealDiaryId) 
                }
        }
        .frame(minWidth: 50)
    }
}
