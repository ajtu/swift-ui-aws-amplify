//
//  TodoListManager.swift
//  
//
//  Created by Alvin Tu on 3/11/21.
//

import Foundation
import Amplify
import AmplifyPlugins
import Combine


class TodoListManager: ObservableObject {
    @Published var todosList: [Todo] = []
    
    init() {
        queryToDos()
//        todosList = queryToDos
//
//        //get data and set to my array
    }
//
//    func move(indices: IndexSet, newOffset:Int) {
//
//        items.move(fromOffsets: indices, toOffset: newOffset)
//
//}
//
//    func addItem() {
//        items.append(Item(id: UUID(), name: "newly added"))
//
//    }
//
//    func delete(at indexSet: IndexSet) {
//        for index in indexSet {
//            items.remove(at:index)
//        }
//    }
//
//    static func emptyState() -> TodoListManager {
//        let manager = TodoListManager(isForTest: true)
//        manager.items = []
//        return manager
//    }
//
//    static func fullState() -> TodoListManager {
//        let manager = TodoListManager(isForTest: false)
//        manager.items = [Item(id: UUID(), name: "first"), Item(id: UUID(), name: "second"), Item(id: UUID(), name: "third")]
//        return manager
//    }
    
//    func subscribeTodos() {
//       self.todoSubscription
//           = Amplify.DataStore.publisher(for: Todo.self)
//               .sink(receiveCompletion: { completion in
//                   print("Subscription has been completed: \(completion)")
//               }, receiveValue: { mutationEvent in
//                   print("Subscription got this value: \(mutationEvent)")
//
//                   do {
//                     let todo = try mutationEvent.decodeModel(as: Todo.self)
//
//                     switch mutationEvent.mutationType {
//                     case "create":
//                       print("Created: \(todo)")
//                     case "update":
//                       print("Updated: \(todo)")
//                     case "delete":
//                        queryToDos()
//                       print("Deleted: \(todo)")
//                     default:
//                       break
//                     }
//
//                   } catch {
//                     print("Model could not be decoded: \(error)")
//                   }
//               })
//    }
//
    
    func queryToDos() {
      Amplify.DataStore.query(Todo.self) { result in
          switch(result) {
          case .success(let todos):
              for todo in todos {
                  print("==== Todo ====")
                  print("Name: \(todo.name)")
                  if let priority = todo.priority {
                      print("Priority: \(priority)")
                  }
                  if let description = todo.description {
                      print("Description: \(description)")
                  }
                DispatchQueue.main.async {
                    self.todosList = todos
                }
              }
          case .failure(let error):
              print("Could not query DataStore: \(error)")
          }
      }
   }
   
    func deleteTodo(with todo: Todo) {
       Amplify.DataStore.query(Todo.self,
                               where: Todo.keys.name.eq(todo.name).and(Todo.keys.id.eq(todo.id)))
 { result in
           switch(result) {
           case .success(let todos):
               guard todos.count == 1, let toDeleteTodo = todos.first else {
                   print("Did not find exactly one todo, bailing")
                   return
               }
               Amplify.DataStore.delete(toDeleteTodo) { result in
                   switch(result) {
                   case .success:
                       print("Deleted item: \(toDeleteTodo.name)")
                    self.queryToDos()
                   case .failure(let error):
                       print("Could not update data in DataStore: \(error)")
                   }
               }
           case .failure(let error):
               print("Could not query DataStore: \(error)")
           }
      }
   }
   
   
   func updateToDo() {
       Amplify.DataStore.query(Todo.self,
                                where: Todo.keys.name.eq("Finish quarterly taxes")) { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, var updatedTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                updatedTodo.name = "File quarterly taxes"
                Amplify.DataStore.save(updatedTodo) { result in
                    switch(result) {
                    case .success(let savedTodo):
                        print("Updated item: \(savedTodo.name)")
                    case .failure(let error):
                        print("Could not update data in DataStore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
   }
   
   
   
    func add(todo: Todo) {
        let item = Todo(name: todo.name,
                        priority: todo.priority,
                        description: todo.description)

       Amplify.DataStore.save(item) { result in
          switch(result) {
          case .success(let savedItem):
              print("Saved item: \(savedItem.name)")
            self.queryToDos()
          case .failure(let error):
              print("Could not save item to DataStore: \(error)")
          }
       }

   }
    
}
