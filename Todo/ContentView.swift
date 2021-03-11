//
//  ContentView.swift
//  Todo
//
//  Created by Alvin Tu on 3/10/21.
//

import SwiftUI
import Combine




struct TodoListView: View {
    
    @ObservedObject var todoManager: TodoListManager
//    @State var todoSubscription: AnyCancellable?

    var body: some View {
        NavigationView {
            ZStack{
            
                List {
                    ForEach(todoManager.todosList) { item in
                        NavigationLink(
                            destination: Text("Destination\(item.name)"),
                            label: {
                                Text(item.name)
                            }
                        )
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            let todo = todoManager.todosList[index]
                            print(todo.name)
                            todoManager.deleteTodo(with: todo)
                              }
                    })
                    .onMove(perform: { indices, newOffset in

//                        todoManager.move(indices: indices, newOffset: newOffset)
                    })
                }
                .navigationBarTitle("Todos", displayMode: .large)
                .toolbar(content: {
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        EditButton()
                        Button(action: {
                            todoManager.add(todo: Todo(id:UUID().uuidString, name: "newly added", priority: .low, description: "newly added"))
                        },
                        label: {Image(systemName: "plus")})
                    }
                })

//                if todoManager.items.count == 0 {
//                    Text("Please start by adding items")
//                        .foregroundColor(.gray)
                }
            }
        
//    }


   
}
}





//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoListView
//}
//}
