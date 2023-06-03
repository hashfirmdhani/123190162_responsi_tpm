import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsi_123190162_mealdb/main.dart';
import 'package:responsi_123190162_mealdb/model/meal_detail.dart';
import 'package:responsi_123190162_mealdb/model/meal_list.dart';
import 'package:responsi_123190162_mealdb/source/meal_source.dart';
import 'package:responsi_123190162_mealdb/meal_category.dart';
import 'package:responsi_123190162_mealdb/meal_list_page.dart';

class DetailPage extends StatefulWidget {
  final MealList data;
  final int index;
  const DetailPage({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int no = widget.index;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Detail of ${widget.data.meals?[no].strMeal}".toTitleCase()),
        actions: [
          IconButton(onPressed: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => MainApp()),
                  (_) => false,
            );
          }, icon: const Icon(Icons.home), iconSize: 30,)
        ],
      ),
      body: _buildDetailMeal(),
    );
  }

  Widget _buildDetailMeal() {
    debugPrint("${widget.data.meals?[no].idMeal}");
    return FutureBuilder(
        future: MealSource.instance
            .loadDetail(idMeal: "${widget.data.meals?[no].idMeal}"),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MealDetail mealdetail = MealDetail.fromJson(snapshot.data);
            return _buildSuccessSection(mealdetail);
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

  Widget _buildSuccessSection(MealDetail data) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildHeader(data),
            _buildDescription(data),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(MealDetail data) {
    return Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 5.0, color: Colors.brown),
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  "${data.meals![0].strMealThumb}",
                  fit: BoxFit.fill,
                  width: 120.0,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200.0,
              height: 140.0,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${data.meals![0].strMeal}".toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Meal ID. ${data.meals![0].idMeal}",
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Koulen'),
                    ),
                    Text(
                      "Meal Category: ${data.meals![0].strCategory}",
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Koulen'),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _buildDescription(MealDetail data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 9),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 5.0, color: Colors.brown.shade700),
          borderRadius: BorderRadius.circular(20),
          color: Colors.brown.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "INSTRUCTIONS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Text(
                "${data.meals![0].strInstructions}",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
