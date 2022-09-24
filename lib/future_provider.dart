
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app/models/cat_fact_model.dart';


final httpClientProvider = Provider<Dio>((ref){
  return Dio(BaseOptions(baseUrl: "https://catfact.ninja/"));
});

final catFactsProvider = FutureProvider.family<List<CatFactModel>, Map<String, dynamic>>((ref, map) async {
  final _dio = ref.watch(httpClientProvider);
  final _result = await _dio.get("facts", queryParameters: map);
  List<Map<String, dynamic>> _mapData = List.from(_result.data["data"]);
  List<CatFactModel> _catFactList = _mapData.map((e) => CatFactModel.fromMap(e)).toList();
  return _catFactList;
});



class FutureProviderExample extends ConsumerWidget {
  const FutureProviderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var _list = ref.watch(catFactsProvider(const {
      "limit" : 4,
      "max_length" : 30
    }));

    return Scaffold(
      body: SafeArea(
        child: _list.when(data: (list){
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(list[index].fact),
              );
            },
          );
        },
          error: (e,s){
          return Container();
          },
          loading: (){
            return CircularProgressIndicator();
          }
        )
      ),
    );
  }
}
