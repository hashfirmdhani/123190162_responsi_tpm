import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsi_123190162_mealdb/model/meal_list.dart';
import 'package:responsi_123190162_mealdb/source/meal_source.dart';
import 'package:responsi_123190162_mealdb/meal_category.dart';


class MealListPage extends StatefulWidget {
  final String value;
  final int index;
  const MealListPage({Key? key, required this.value, required this.index}) : super(key: key);

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List By:  ${widget.value}"),
        actions: [
          IconButton(onPressed: () async {
          }, icon: const Icon(Icons.home), iconSize: 30,)
        ],
      ),
      body: _buildListMeal(),
    );
  }

  Widget _buildListMeal() {
    return FutureBuilder(
        future:
        MealSource.instance.loadByCategory(category: widget.value),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MealList mealList =
            MealList.fromJson(snapshot.data);
            return _buildSuccessSection(mealList);
          }
          return _buildLoadingSection();
        });
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    return Center(
        child: Text("No Internet Connection", textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)));
  }

  Widget _buildSuccessSection(MealList data) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: data.meals != null ? ListView.builder(
                itemCount: data.meals?.length,
                itemBuilder: (BuildContext context, int index){
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              decoration:
                              BoxDecoration(
                                  border: Border.all(color: Colors.brown.shade800, width: 3.0,),
                                  borderRadius: BorderRadius.circular(15),
                                color: Colors.brown.withOpacity(0.7),
                              ),
                              child: InkWell(
                                  child: _buildItemList(
                                    data, index
                                  ))),
                        );
                    })
                : Center(
                  child: Center(
                      child: Text("Resep Tidak Ada", textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)))),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(MealList data, int index) {
    String imageUrl = "${data.meals![index].strMealThumb}";
    var text = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.brown.shade800,
              ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    imageUrl,
                    width: 130.0,
                    fit: BoxFit.contain,
                  ),
                ),
            ),
            ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text("${data.meals![index].strMeal}".toTitleCase(), style: const TextStyle(fontSize: 28.0)),
          )),
          // Expanded(child: Text(value2.toTitleCase(), style: const TextStyle(fontSize: 26.0))),
        ],
      ),
    );
    return text;
  }
}
