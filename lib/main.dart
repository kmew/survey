import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:survey/services/crud.dart';
import 'package:survey/form.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Band Name Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  String Name;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      margin: EdgeInsets.only(top: 3.0, bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 15.0),
            blurRadius: 5.0,
          )
        ],
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                document['name'],
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFddddff),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                document['votes'].toString(),
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        color: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          crudMedthods().plusData(document.reference);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: FlatButton(
                        color: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          crudMedthods().minusData(document.reference);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posible Band Names'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('bandnames').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(index.toString()),
                  child: _buildListItem(context, snapshot.data.documents[index]),
                  onDismissed: (direction) {
                    if(direction == DismissDirection.startToEnd) {
                      print("SWIPE: RIGHT");
                    } else if(direction == DismissDirection.endToStart) {
                      print("SWIPE: LEFT");
                    }
                    crudMedthods().deleteData(snapshot.data.documents[index].documentID);
                  },
                  background: Container(
                    color: Colors.red,
                  ),
                );
              },
            );
          }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormScreen(
              onTypeForm: (String typing) {
                setState(() {
                  Name = typing;
                });
              },
              onSubmitName: () {
                print("Submit: $Name");
                crudMedthods().addData(Name);
              },
            )),
          );
        },
        label: Text('ADD'),
      ),
    );
  }
}

