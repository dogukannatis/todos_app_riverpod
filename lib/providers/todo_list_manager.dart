
import 'package:riverpod/riverpod.dart';
import 'package:todos_app/models/todo_model.dart';
import 'package:uuid/uuid.dart';




class TodoListManager extends StateNotifier<List<TodoModel>> {
  TodoListManager([List<TodoModel>? initialTodos]) : super(initialTodos ?? []);
  
  void addTodo(String description){
    state = [...state, TodoModel(id: const Uuid().v4(), description: description)];
  }

  void toggle(String id){
    state = [
      for(var todo in state)
        if(todo.id == id)
          TodoModel(
            id: todo.id,
            description: todo.description,
            completed: !todo.completed
          )else todo,
    ];
  }

  void edit({required String id, required String newDescription}){
    state = [
      for(var todo in state)
        if(todo.id == id)
          TodoModel(
            id: todo.id,
            description: newDescription,
            completed: todo.completed
          ) else todo
    ];
  }

  void remove(TodoModel todo){
    state = state.where((element) => element.id != todo.id).toList();
  }

  int unCompletedTodoCount(){
    return state.where((element) => !element.completed).length;
  }

}