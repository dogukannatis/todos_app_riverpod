import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app/future_provider.dart';
import 'package:todos_app/providers/all_providers.dart';
import 'package:todos_app/widgets/title_widget.dart';
import 'package:todos_app/widgets/todo_list_item_widget.dart';
import 'package:todos_app/widgets/toolbar_widget.dart';

import 'package:uuid/uuid.dart';

import 'models/todo_model.dart';

class TodoApp extends ConsumerWidget {
  TodoApp({Key? key}) : super(key: key);

  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var allTodos = ref.watch(filteredTodoList);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          const TitleWidget(),
          TextField(
            controller: newTodoController,
            decoration:
                const InputDecoration(labelText: 'Neler Yapacaksın Bugün ?'),
            onSubmitted: (newTodo) {
              ref.read(todoListProvider.notifier).addTodo(newTodo);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ToolBarWidget(),
          for (var i = 0; i < allTodos.length; i++)
            Dismissible(
                key: ValueKey(allTodos[i].id),
                onDismissed: (_){
                  ref.read(todoListProvider.notifier).remove(allTodos[i]);
                },
                child: ProviderScope(
                  overrides: [
                    currentTodoProvider.overrideWithValue(allTodos[i])
                  ],
                    child: const TodoListItemWidget())
            ),
          TextButton(
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => FutureProviderExample()),);
            },
            child: Text("Future Provider Page"),
          )
        ],
      ),
    );
  }
}
