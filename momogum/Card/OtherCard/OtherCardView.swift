//
//  OtherCardView.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct OtherCardView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isTabBarHidden: Bool
    
    @StateObject private var viewModel = CardViewModel()
    
    @State private var showBookmarkText = false
    
    var userID: Int
    var mealDiaryId: Int

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        isTabBarHidden = false
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleReportSheet()
                    }) {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .frame(height: 60)
                .background(Color.white)
            }
            .zIndex(1)

            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Spacer().frame(height: 70)

                    UserInfoView(viewModel: viewModel)
                        .padding(.leading, 22)
                    
                    Spacer().frame(height: 10)

                    ZStack {
                        if let imageUrl = viewModel.card.mealDiaryImageURL, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable().aspectRatio(1, contentMode: .fit)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Color.gray.frame(maxWidth: .infinity)
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(viewModel.getRevisitImage())
                                    .resizable()
                                    .frame(width: 72, height: 72)
                                    .padding(20)
                            }
                        }
                    }

                    Spacer().frame(height: 5)
                    
                    HStack {
                        Spacer().frame(width: 10)
                        HeartView(viewModel: viewModel, mealDiaryId: mealDiaryId)
                            .fixedSize()
                        Spacer().frame(width: 20)
                        CommentView(viewModel: viewModel, mealDiaryId: mealDiaryId)
                        Spacer()
                        BookmarkView(
                            viewModel: viewModel,
                            mealDiaryId: mealDiaryId,
                            onBookmarkToggled: {
                                showBookmarkText = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showBookmarkText = false
                                }
                            }
                        )
                        Spacer().frame(width: 10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    
                    Spacer().frame(height: 5)

                    Button(action: {
                        viewModel.toggleHeartBottomSheet()
                    }) {
                        Text("\(viewModel.card.likeCount)명이 이 밥일기를 좋아합니다.")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .padding(.leading, 28)
                            .padding(.top, 5)
                            .frame(height: 20)
                    }
                    
                    Spacer().frame(height: 5)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image("map")
                                .resizable()
                                .frame(width: 10, height: 13)
                                .padding(.trailing, 5)
                            
                            Text(viewModel.card.location)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                        
                        HStack {
                            Image("forkknife")
                                .resizable()
                                .frame(width: 12, height: 13)
                                .padding(.trailing, 5)
                            
                            Text(viewModel.card.keywords.joined(separator: ", "))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 28)
                    .padding(.top, 5)

                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 330, height: 79)

                        ScrollView {
                            Text(viewModel.card.reviewText)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 24)
                                .padding(.leading, 24)
                        }
                        .frame(width: 330, height: 79, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.leading, 28)
                    .padding(.top, 30)
                }
                .padding(.bottom, 20)
            }
            
            BookmarkPopupView(showBookmarkText: $showBookmarkText)
        }
        .onAppear{
            isTabBarHidden = true
        }
        .onDisappear{
            isTabBarHidden = false
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        .sheet(isPresented: $viewModel.showHeartBottomSheet) {
            HeartBottomSheetView(viewModel: viewModel, mealDiaryId: mealDiaryId)
                .presentationDetents([.fraction(2/3)])
        }
        
        .sheet(isPresented: $viewModel.showReportSheet) {
            ReportBottomSheet(viewModel: viewModel, mealDiaryId: mealDiaryId)
                .presentationDetents([.fraction(2/3)])
        }
        
        .alert("신고가 접수되었습니다.", isPresented: $viewModel.showCompletedAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("검토는 최대 24시간 소요됩니다.")
        }
    }
}
