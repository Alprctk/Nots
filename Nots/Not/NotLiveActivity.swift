//
//  NotLiveActivity.swift
//  Not
//
//  Created by Alper Çatak on 17.07.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NotAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NotLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NotAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension NotAttributes {
    fileprivate static var preview: NotAttributes {
        NotAttributes(name: "World")
    }
}

extension NotAttributes.ContentState {
    fileprivate static var smiley: NotAttributes.ContentState {
        NotAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NotAttributes.ContentState {
         NotAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NotAttributes.preview) {
   NotLiveActivity()
} contentStates: {
    NotAttributes.ContentState.smiley
    NotAttributes.ContentState.starEyes
}
