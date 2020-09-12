import 'dart:convert';
import 'dart:io';
import 'dart:async';
// import 'package:html/dom.dart';
// import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';

void main(List<String> arguments) {
  final String sitemapUrl =
      arguments.firstWhere((element) => element.endsWith('.xml'));
  final int threadsArgument = int.parse(arguments
      .firstWhere((element) => element.startsWith('threads='))
      .split('=')
      .last);
}

initiate(String sitemapUrl) async {
  final dio = Dio();

  final response = await dio.get(sitemapUrl);
  final result = response.data;
  print(result);
  return result;
}

List generateWorkers(threadsCount) {
  List workers = [];
  for (var i = 0; i < threadsCount - 1; i++) {
    workers.add(Dio());
  }
  return workers;
}

// // returns stream
// utilizator(List<Dio> workers, List dataList){
//   while (dataList.length >0){
//     workers.firstWhere((dio) => dio.)
//   }
// }
