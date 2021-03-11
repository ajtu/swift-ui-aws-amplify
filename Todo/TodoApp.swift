//
//  TodoApp.swift
//  Todo
//
//  Created by Alvin Tu on 3/10/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins


@main
struct TodoApp: App {
    @StateObject var todoManager = TodoListManager()

    public init() {
        Amplify.Logging.logLevel = .info
            configureAmplify()

        }
    var body: some Scene {
        WindowGroup {
            TodoListView(todoManager: todoManager)
        }
    }
}


func configureAmplify() {
   let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
   do {
       try Amplify.add(plugin: dataStorePlugin)
       try Amplify.configure()
       print("Initialized Amplify");
   } catch {
       // simplified error handling for the tutorial
       print("Could not initialize Amplify: \(error)")
   }
}
