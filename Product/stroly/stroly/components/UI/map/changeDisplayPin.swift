//
//  changeDisplayPin.swift
//  stroly
//
//  Created by 大沼優希人 on 2024/01/23.
//

import SwiftUI

class changeDisplayPinModel: ObservableObject {
    @Published var selectedPublic: Bool = UserDefaults.standard.bool(forKey: "selectedPublic")
    @Published var selectedFriend: Bool = UserDefaults.standard.bool(forKey: "selectedFriend")
    @Published var selectedMyOwn: Bool = UserDefaults.standard.bool(forKey: "selectedMyOwn")

    func toggleButton(_ buttonNumber: Int) {
        switch buttonNumber {
        case 1:
            selectedPublic.toggle()
            UserDefaults.standard.set(selectedPublic, forKey: "selectedPublic")
            print("ボタン1の選択状態: \(selectedMyOwn)")
            print("ボタン2の選択状態: \(selectedFriend)")
            print("ボタン3の選択状態: \(selectedPublic)")
        case 2:
            selectedFriend.toggle()
            UserDefaults.standard.set(selectedFriend, forKey: "selectedFriend")
            print("ボタン1の選択状態: \(selectedMyOwn)")
            print("ボタン2の選択状態: \(selectedFriend)")
            print("ボタン3の選択状態: \(selectedPublic)")
        case 3:
            selectedMyOwn.toggle()
            UserDefaults.standard.set(selectedMyOwn, forKey: "selectedMyOwn")
            print("ボタン1の選択状態: \(selectedMyOwn)")
            print("ボタン2の選択状態: \(selectedFriend)")
            print("ボタン3の選択状態: \(selectedPublic)")
        default:
            break
        }
    }
}

struct changeDisplayPin: View {
    @ObservedObject var model: changeDisplayPinModel

    // パディングとスペースの設定
    let horizontalPadding: CGFloat = 20
    let buttonSpacing: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("表示するピン")
                    .font(.headline)
                    .padding(.top, 20)

                HStack(spacing: buttonSpacing) {
                    Button(action: {
                        model.toggleButton(1)
                    }) {
                        VStack {
                            Image(systemName: "globe")
                                .font(.title)
                            Text("パブリック")
                                .bold()
                                .font(.title3)
                        }
                    }
                    .buttonStyle(GrayButtonStyle(isSelected: model.selectedPublic, size: calculateButtonSize(screenWidth: geometry.size.width)))
                    
                    Button(action: {
                        model.toggleButton(2)
                    }) {
                        VStack {
                            Image(systemName: "person.2")
                                .font(.title)
                            Text("フレンド")
                                .bold()
                                .font(.title3)
                        }
                    }
                    .buttonStyle(GrayButtonStyle(isSelected: model.selectedFriend, size: calculateButtonSize(screenWidth: geometry.size.width)))
                    
                    Button(action: {
                        model.toggleButton(3)
                    }) {
                        VStack {
                            Image(systemName: "lock")
                                .font(.title)
                            Text("プライベート")
                                .bold()
                                .font(.title3)
                        }
                    }
                    .buttonStyle(GrayButtonStyle(isSelected: model.selectedMyOwn, size: calculateButtonSize(screenWidth: geometry.size.width)))

                }
                .padding(.top, 20)
            }
            .padding(.horizontal, horizontalPadding)
        }
    }

    func calculateButtonSize(screenWidth: CGFloat) -> CGFloat {
        let totalSpacing = buttonSpacing * 2 // 2つの間隔
        let totalWidth = screenWidth - (horizontalPadding * 2) - totalSpacing
        return totalWidth / 3
    }
}

struct GrayButtonStyle: ButtonStyle {
    var isSelected: Bool
    var size: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .foregroundColor(.white)
            .background(isSelected ? Color(hex: 0xB6CC77) : Color.gray)
            .cornerRadius(5)
    }
}


extension Color {
    init(hex: UInt) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
