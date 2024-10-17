//
//  PlayerView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import AVKit
import SwiftUI

class PlayerUIView: UIView {
    // MARK: Class Property

    let playerLayer = AVPlayerLayer()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerSetup(player: player)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Life-Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    // MARK: Class Methods

    private func playerSetup(player: AVPlayer) {
        playerLayer.player = player
        player.actionAtItemEnd = .none
        layer.addSublayer(playerLayer)
        playerLayer.backgroundColor = UIColor.white.cgColor // <--- Set color here
    }
}

struct PlayerView: UIViewRepresentable {
    @Binding var player: AVPlayer

    func makeUIView(context _: Context) -> PlayerUIView {
        PlayerUIView(player: player)
    }

    func updateUIView(_ uiView: PlayerUIView, context _: UIViewRepresentableContext<PlayerView>) {
        uiView.playerLayer.player = player
    }
}
