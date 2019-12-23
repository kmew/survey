import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class crudMedthods {

  Future<void> addData(Name) async{
    await print("CREATING");
    await Firestore.instance.collection('bandnames').document().setData(
      {
        'name': Name,
        'votes': 0,
      }
    );
  }

  Future<void> deleteData(ID) async{
    await print("DELETING");
    await print(ID);
    await Firestore.instance.collection('bandnames').document(ID).delete();
  }

  Future<void> plusData(docRef) async{
    await print("ADDING");
    await Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap =
      await transaction.get(docRef);
      await transaction.update(freshSnap.reference, {
        'votes': freshSnap['votes'] + 1,
      });
    });
  }

  Future<void> minusData(docRef) async{
    await print("REDUCING");
    await Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap =
      await transaction.get(docRef);
      if(freshSnap['votes'] > 0) {
        await transaction.update(freshSnap.reference, {
          'votes': freshSnap['votes'] - 1,
        });
      } else {
        await transaction.update(freshSnap.reference, {
          'votes': freshSnap['votes'],
        });
      }
    });
  }
}