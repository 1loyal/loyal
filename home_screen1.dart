import 'package:f/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:f/model/Item.dart';

class home1 extends StatefulWidget {
  const home1({super.key});

  @override
  State<home1> createState() => _home1State();
}
class _home1State extends State<home1> {
  @override
  final apiservice api = apiservice();
  Widget build(BuildContext context) {
      return Scaffold(
        body: FutureBuilder<List<Item>>(
            future: api.fetchItems(),
            builder: (context,snap){
              if(!snap.hasData) return Center(child: CircularProgressIndicator());
              final items = snap.data!;
              
              if(items.isEmpty) return Center(child: Text("no item"));
              
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i){
                    final item = items[i];
                    return ListTile(
                      title: Text(item.title ?? ""),
                      subtitle: Text(item.body ?? ""),

                    );
                  }
              );
            }
            
        ),
      );
  }
}
