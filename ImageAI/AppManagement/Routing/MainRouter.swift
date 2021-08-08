//
//  MainRouter.swift
//  ImageAI
//
//  Created by Martin Lukacs on 08/08/2021.
//

import SwiftUI
import SwiftUICombineToolBox

final class MainRouter {}

enum MainTabDestinationType {
    case video
    case photo
    case library

    static func getName(for type: MainTabDestinationType) -> String {
        var name: String!

        switch type {
        case .video:
            name = "For You"
        case .photo:
            name = "Meditations"
        case .library:
            name = "Your library"
        }
        return name
    }

    static func getIconName(for type: MainTabDestinationType) -> String {
        var iconName: String!
        switch type {
        case .video:
            iconName = "video"
        case .photo:
            iconName = "camera"
        case .library:
            iconName = "building.columns"
        }
        return iconName
    }

    static func getTabNumber(for type: MainTabDestinationType) -> Int {
        var tabNumber: Int!
        switch type {
        case .video:
            tabNumber = 0
        case .photo:
            tabNumber = 1
        case .library:
            tabNumber = 2
        }
        return tabNumber
    }
}

// MARK: - Tab view navigation

protocol MainTabNavigation {
    func goToPage(for destination: MainTabDestinationType) -> AnyView
}

extension MainRouter: MainTabNavigation {
    func goToPage(for destination: MainTabDestinationType) -> AnyView {
        switch destination {
        case .video:
            return Text("Account").eraseToAnyView()
        case .photo:
            return Text("Account").eraseToAnyView()
        case .library:
            return Text("Account").eraseToAnyView()
        }
    }
}
