//
//  MainWidgetProvider.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import SwiftUI
import WidgetKit

struct MainWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MainWidgetEntry {
        MainWidgetEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MainWidgetEntry) -> Void) {
        completion(MainWidgetEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MainWidgetEntry>) -> Void) {
        completion(Timeline(entries: [], policy: .never))
    }
}
