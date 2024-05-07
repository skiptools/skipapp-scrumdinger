/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation
import AVKit

//extension AVPlayer {
//    static let sharedDingPlayer: AVPlayer = loadSharedDingPlayer()
//
//}

let sharedDingPlayer = loadSharedDingPlayer()

private func loadSharedDingPlayer() -> AVPlayer {
    guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else { fatalError("Failed to find sound file.") }
    return AVPlayer(url: url)
}
