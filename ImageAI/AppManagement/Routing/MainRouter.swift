//
//  MainRouter.swift
//  ImageAI
//
//  Created by Martin Lukacs on 08/08/2021.
//

import SwiftUI
import SwiftUICombineToolBox

final class MainRouter {}

enum MainTabBarDestinationType {
    case video
    case photo
    case library

    func getName() -> String {
        switch self {
        case .video:
            return "Video detection"
        case .photo:
            return "Photo detection"
        case .library:
            return "Library"
        }
    }

    func getIconName() -> String {
        switch self {
        case .video:
            return "video"
        case .photo:
            return "camera"
        case .library:
            return "building.columns"
        }
    }

    func getTabNumber() -> Int {
        switch self {
        case .video:
            return 0
        case .photo:
            return 1
        case .library:
            return 2
        }
    }
}

// MARK: - Tab view navigation

protocol MainTabNavigation {
    func goToPage(for destination: MainTabBarDestinationType) -> AnyView
}

extension MainRouter: MainTabNavigation {
    func goToPage(for destination: MainTabBarDestinationType) -> AnyView {
        switch destination {
        case .video:
            return VideoView().eraseToAnyView()
        case .photo:
            return Text("Account").eraseToAnyView()
        case .library:
            return Text("Account").eraseToAnyView()
        }
    }
}
