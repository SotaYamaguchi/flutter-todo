// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:rapido/rapido.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData.dark(),
      navigatorObservers: <NavigatorObserver>[observer],
      home: MyHomePage(
        title: 'Todo List',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  final DocumentList documentList = DocumentList(
    "task list",
    labels: {"開始日": "date", "タイトル": "task", "場所": "location"},
  );

  Widget _customItemBuilder(int index, Document doc, BuildContext context) {
    return Card(
        child: Row(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _showItemIcon(),
              _showItemTask(index),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _showOtherItem(index),
              _showActionsButton(index, doc, context),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _showItemIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Icon(Icons.flight_land),
    );
  }

  Widget _showItemTask(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        documentList[index]["task"],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _showOtherItem(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        children: <Widget>[
          Text(documentList[index]["date"]),
          Text(documentList[index]["location"]),
        ],
      ),
    );
  }

  Widget _showActionsButton(int index, Document doc, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: DocumentActionsButton(documentList, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(
      documentList,
      title: "Todo List",
      customItemBuilder: _customItemBuilder,
      emptyListWidget: Center(
        child: Text("タスクを追加してください"),
      ),
      decoration: BoxDecoration(color: Colors.black38),
    );
  }
}
