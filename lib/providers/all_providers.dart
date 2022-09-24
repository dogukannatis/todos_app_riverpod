import 'package:riverpod/riverpod.dart';
import 'package:todos_app/providers/todo_list_manager.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';


enum TodoListFilter{all, active, completed}


final todoListFilter = StateProvider<TodoListFilter>((ref){
  return TodoListFilter.all;
});

final filteredTodoList = Provider<List<TodoModel>>((ref){
  final filter = ref.watch(todoListFilter);
  final todoList = ref.watch(todoListProvider);
  switch(filter){
    case TodoListFilter.all:
      return todoList;
    case TodoListFilter.completed:
      return todoList.where((element) => element.completed).toList();
    case TodoListFilter.active:
      return todoList.where((element) => !element.completed).toList();
  }
});

final todoListProvider = StateNotifierProvider<TodoListManager, List<TodoModel>>((ref){
  return TodoListManager([
    TodoModel(
      id: const Uuid().v4(),
      description: "Spoara git",
    ),
    TodoModel(
      id: const Uuid().v4(),
      description: "Ödevleri bitir",
    ),
  ]);
});

final unCompletedTodoCount = Provider<int>((ref){
  final allTodo = ref.watch(todoListProvider);
  final count = allTodo.where((element) => !element.completed).length;
  return count;
});

final currentTodoProvider = Provider<TodoModel>((ref){
  throw UnimplementedError();
});