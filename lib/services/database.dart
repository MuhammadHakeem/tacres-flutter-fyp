import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tacres_draft/model/records.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference actRecordCollection =
      FirebaseFirestore.instance.collection('actRecord');

  Future updateActRecord(
      String date, int actScore, String description, String weather) async {
    return await actRecordCollection.doc(uid).set({
      'date': date,
      'actScore': actScore,
      'description': description,
      'weather': weather
    });
  }

  // actRecords from snapshot
  List<Record> _recordListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Record(
        Date: doc.get("date") ?? '',
        ActScore: doc.get('actScore') ?? 0,
        Description: doc.get('description') ?? '',
        Weather: doc.get('weather') ?? '',
      );
    }).toList();
  }

  //get actRecord streams
  Stream<List<Record>> get actRecord {
    return actRecordCollection.snapshots().map(_recordListFromSnapshot);
  }
}
