//
//  EyeNeighborView.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/25.
//

import SwiftUI

struct SceneNeighborEye: View {
    @Binding var roomUser: User
    @State private var eyeNeighborViewModel = EyeNeighborViewModel()
    @State private var isInactiveOrSleep = false
    var isJumping: Bool
    
    var body: some View {
        EyeView(isSmiling: eyeNeighborViewModel.isSmiling,
                isBlinkingLeft: eyeNeighborViewModel.isBlinkingLeft,
                isBlinkingRight: eyeNeighborViewModel.isBlinkingRight,
                lookAtPoint: eyeNeighborViewModel.lookAtPoint,
                faceOrientation: eyeNeighborViewModel.faceOrientation,
                bodyColor: eyeNeighborViewModel.bodyColor,
                eyeColor: eyeNeighborViewModel.eyeColor, cheekColor: eyeNeighborViewModel.cheekColor, isInactiveOrSleep: isInactiveOrSleep, isJumping: isJumping)
        .onAppear {
            eyeNeighborViewModel.update(roomUser: roomUser)
            //이웃 눈의 랜덤한 움직임 함수 실행
            withAnimation(.linear(duration: 3)) {
                eyeNeighborViewModel.randomEyeMove(roomUser: roomUser)
            }
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
                DispatchQueue.main.async {
                    withAnimation(.linear(duration: 3)) {
                        eyeNeighborViewModel.randomEyeMove(roomUser: roomUser)
                    }
                }
            }
        }
    }
}

struct SceneNeighborEye_Previews: PreviewProvider {
    static var previews: some View {
        SceneNeighborEye(roomUser: .constant(User.UTData[0][1]), isJumping: false)
    }
}
