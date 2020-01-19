//
//  Extensions.swift
//  TransitTrack
//
//  Copyright © 2020 Kevin Hua. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

extension JSON {
    func isNextBusError() -> Bool {
        return self["Error"].exists()
    }
}

extension Double {
    func toDateString() -> String {
        let date = Date(timeIntervalSinceReferenceDate: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

extension ColorScheme {
    func toBackgroundColor() -> Color {
        if self == .dark {
            return Color.black
        } else {
            return Color.white
        }
    }
}

struct HideListDivider: ViewModifier {
    func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
        }
        .onDisappear {
            UITableView.appearance().separatorStyle = .singleLine
        }
    }
}
