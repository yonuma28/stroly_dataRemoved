//
//  StampButtom.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/25.
//

import SwiftUI

struct PostCardStampButton: View {
    @ObservedObject var stampModel: StampModel
    @State var postId: Int

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                // ボタンがタップされたときのアクション
                if(stampModel.tappedStamp == 0){
                    stampModel.tappedStamp = 1
                    stampModel.addStamps(postId: postId, stampId: stampModel.tappedStamp)
                } else if (stampModel.tappedStamp == 1) {
                    stampModel.deleteStamps(postId: postId, stampId: 1)
                }
                
            }) {
                if(stampModel.tappedStamp != 1){
                    VStack{
                        Text("👍")
                            .font(.title)
                        Text("\(stampModel.numberOfGood)")
                            .bold()
                    }
                        .padding()
                        .frame(width: 72, height: 72)
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundColor(Color.black)
                        )
                }
                else if(stampModel.tappedStamp == 1){
                    VStack{
                        Text("👍")
                            .font(.largeTitle)
                        Text("\(stampModel.numberOfGood)")
                            .bold()
                    }
                        .padding()
                        .frame(width: 72, height: 72)
                        .foregroundColor(Color.black)
                        .background(Color(0xB6CC77))
                        .clipShape(Circle())
                }
            }
                        
            Spacer()

            Button(action: {
                // ボタンがタップされたときのアクション
                if(stampModel.tappedStamp == 0){
                    stampModel.tappedStamp = 2
                    stampModel.addStamps(postId: postId, stampId: stampModel.tappedStamp)
                } else if (stampModel.tappedStamp == 2) {
                    stampModel.deleteStamps(postId: postId, stampId: 2)
                }
                
            }) {
                if(stampModel.tappedStamp != 2){
                    VStack{
                        Text("🔥")
                            .font(.title)
                        Text("\(stampModel.numberOfFire)")
                            .bold()
                    }
                    .padding()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(Color.black)
                    )
                }
                else if(stampModel.tappedStamp == 2){
                    VStack{
                        Text("🔥")
                            .font(.largeTitle)
                        Text("\(stampModel.numberOfFire)")
                            .bold()
                    }
                    .padding()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color.black)
                    .background(Color(0xB6CC77))
                    .clipShape(Circle())
                
                }
            }
            
            
            Spacer()
            
            Button(action: {
                // ボタンがタップされたときのアクション
                if(stampModel.tappedStamp == 0){
                    stampModel.tappedStamp = 3
                    stampModel.addStamps(postId: postId, stampId: stampModel.tappedStamp)
                } else if (stampModel.tappedStamp == 3) {
                    stampModel.deleteStamps(postId: postId, stampId: 3)
                }
            }) {
                if(stampModel.tappedStamp != 3){
                    VStack{
                        Text("❤️")
                            .font(.title)
                        Text("\(stampModel.numberOfHeart)")
                            .bold()
                    }
                    .padding()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(Color.black)
                    )
                }
                else if(stampModel.tappedStamp == 3){
                    VStack{
                        Text("❤️")
                            .font(.largeTitle)
                        Text("\(stampModel.numberOfHeart)")
                            .bold()
                    }
                    .padding()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color.black)
                    .background(Color(0xB6CC77))
                    .clipShape(Circle())
                }
            }
            
            
            Spacer()
            
            Button(action: {
                // ボタンがタップされたときのアクション
                if(stampModel.tappedStamp == 0){
                    stampModel.tappedStamp = 4
                    stampModel.addStamps(postId: postId, stampId: stampModel.tappedStamp)
                } else if (stampModel.tappedStamp == 4) {
                    stampModel.deleteStamps(postId: postId, stampId: 4)
                }
                
            }) {
                if(stampModel.tappedStamp != 4){
                    VStack{
                        Text("🎉")
                            .font(.title)
                        Text("\(stampModel.numberOfCracker)")
                            .bold()
                    }
                    .padding()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(Color.black)
                    )
                }
                else if(stampModel.tappedStamp == 4){
                    VStack{
                        Text("🎉")
                            .font(.largeTitle)
                        Text("\(stampModel.numberOfCracker)")
                            .bold()
                    }
                    .padding()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color.black)
                    .background(Color(0xB6CC77))
                    .clipShape(Circle())
                }
            }
            
            Spacer()}
    }
}
