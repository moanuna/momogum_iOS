//
//  CommentBottomSheetView.swift
//  momogum
//
//  Created by 조승연 on 2/5/25.
//

import SwiftUI

struct CommentBottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newComment = ""
    @State private var submitFailed = false
    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: CardViewModel
    
    var mealDiaryId: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 8)
            
            Text("댓글")
                .font(.system(size: 18, weight: .semibold))
                .padding(.top, 24)
            
            Divider()
                .frame(width: 304.5, height: 0.5)
                .background(Color.gray.opacity(0.5))
                .padding(.top, 24)
            
            List {
                ForEach(viewModel.comments.indices, id: \.self) { index in
                    let comment = viewModel.comments[index]
                    VStack(spacing: 8) {
                        HStack {
                            if let imagePath = comment.userProfileImagePath, let url = URL(string: imagePath) {
                                AsyncImage(url: url) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 52, height: 52)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 52, height: 52)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 52, height: 52)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(comment.nickname)
                                        .font(.system(size: 16, weight: .bold))
                                    
//                                    Text("방금")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(.gray)
                                }
                                Text(comment.content)
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
            .frame(width: 320)
            .scrollIndicators(.hidden)
            
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 353, height: 62)
                    .overlay(
                        HStack {
                            TextField("댓글 쓰기", text: $newComment)
                                .padding(.leading, 12)
                                .foregroundColor(.black)
                                .focused($isFocused)
                                .disabled(viewModel.isSubmittingComment)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.addComment(mealDiaryId: mealDiaryId, comment: newComment) { success in
                                    if success {
                                        newComment = ""
                                        isFocused = false
                                    } else {
                                        submitFailed = true
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(newComment.isEmpty ? .gray : .white)
                                }
                                .frame(width: 72, height: 28)
                                .background(newComment.isEmpty ? Color.gray.opacity(0.2) : Color.red)
                                .cornerRadius(12)
                            }
                            .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isSubmittingComment)
                            .padding(.trailing, 10)
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .interactiveDismissDisabled(viewModel.isSubmittingComment)
        .alert("댓글을 등록하지 못했어요. 다시 시도해 주세요.", isPresented: $submitFailed) {}
        .presentationDetents([.fraction(2/3)])
    }
}
