import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsi_123190162_mealdb/model/meal_category_list.dart';
import 'package:responsi_123190162_mealdb/source/meal_source.dart';
import 'package:responsi_123190162_mealdb/meal_list_page.dart';


class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key? key}) : super(key: key);

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  String toUnderScore() => replaceAll(" ", "_").toLowerCase();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Category"),
      ),
      body: _buildListCategory()
    );
  }

  Widget _buildListCategory(){
    return FutureBuilder(
        future: MealSource.instance.loadCategories(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MealCategoryList categoryList =
            MealCategoryList.fromJson(snapshot.data);
            return _buildSuccessSection(categoryList);
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
    return const Text("Error2");
  }

  Widget _buildSuccessSection(MealCategoryList data) {
    return ListView.builder(
      padding: EdgeInsets.all(3.0),
      itemCount: data.categories?.length,
      itemBuilder: (BuildContext context, int index) {
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
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return MealListPage(value: "${data.categories?[index].strCategory}", index: 1);
                        })
                    );
                  },
                  child: _buildMealCategory(data, index
                  )),
            ));
      },
    );
  }

  Widget _buildMealCategory(MealCategoryList data, int index) {
    String imageUrl = "${data.categories![index].strCategoryThumb}";
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
            child: Text("${data.categories![index].strCategory}".toTitleCase(), style: const TextStyle(fontSize: 28.0)),
          )),
          // Expanded(child: Text(value2.toTitleCase(), style: const TextStyle(fontSize: 26.0))),
        ],
      ),
    );
    return text;
  }
}

