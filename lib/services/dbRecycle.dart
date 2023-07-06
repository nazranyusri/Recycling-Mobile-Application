import 'package:cloud_firestore/cloud_firestore.dart';

class dbRecycle{
  // Collection reference
  final CollectionReference recycleCollection = FirebaseFirestore.instance.collection('recycle');

  Future<void> addRecycleData(
    String userEmail,
    double weight,
    double plastic,
    double glass,
    double paper,
    double rubber,
    double metal,
    double paymentTotal,
    double point,
  ) async {
    try {
      final DocumentReference documentRef = recycleCollection.doc(userEmail);

      await documentRef.set({
        'username': userEmail,
      });

      final CollectionReference newDataCollection = documentRef.collection('data');

      await newDataCollection.add({
        'username': userEmail,
        'weight': weight,
        'plastic': plastic,
        'glass': glass,
        'paper': paper,
        'rubber': rubber,
        'metal': metal,
        'money': paymentTotal,
        'point': point,
      });
    } catch (error) {
      // Handle the error
      print('Error adding recycle data: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getCumulativeWeights() async {
    List<Map<String, dynamic>> cumulativeWeights = [];

    try {
      final CollectionReference recycleCollection = FirebaseFirestore.instance.collection('recycle');
      QuerySnapshot snapshot = await recycleCollection.get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs.map((doc) => doc as QueryDocumentSnapshot<Map<String, dynamic>>).toList();
      print('Number of documents: ${documents.length}');

      // Initialize the cumulative totals for each type
      double cumulativePlastic = 0;
      double cumulativeGlass = 0;
      double cumulativePaper = 0;
      double cumulativeRubber = 0;
      double cumulativeMetal = 0;

      // Calculate the cumulative weights
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documents) {
        CollectionReference newDataCollection = doc.reference.collection('data');
        QuerySnapshot dataSnapshot = await newDataCollection.get();

        // Cast the dataSnapshot.docs list to the correct type
        List<QueryDocumentSnapshot<Map<String, dynamic>>> dataDocs = dataSnapshot.docs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>();
        print('Number of data documents: ${dataDocs.length}');

        for (QueryDocumentSnapshot<Map<String, dynamic>> dataDoc in dataDocs) {
          Map<String, dynamic>? data = dataDoc.data();

          double plasticWeight = data['plastic'] ?? 0;
          double glassWeight = data['glass'] ?? 0;
          double paperWeight = data['paper'] ?? 0;
          double rubberWeight = data['rubber'] ?? 0;
          double metalWeight = data['metal'] ?? 0;

          cumulativePlastic += plasticWeight;
          cumulativeGlass += glassWeight;
          cumulativePaper += paperWeight;
          cumulativeRubber += rubberWeight;
          cumulativeMetal += metalWeight;
        }
      }

      //troubleshoot
      print('Cumulative Plastic: $cumulativePlastic');
      print('Cumulative Glass: $cumulativeGlass');
      print('Cumulative Paper: $cumulativePaper');
      print('Cumulative Rubber: $cumulativeRubber');
      print('Cumulative Metal: $cumulativeMetal');

      // Add the cumulative totals to the list
      cumulativeWeights.add({'type': 'Plastic', 'totalWeight': cumulativePlastic});
      cumulativeWeights.add({'type': 'Glass', 'totalWeight': cumulativeGlass});
      cumulativeWeights.add({'type': 'Paper', 'totalWeight': cumulativePaper});
      cumulativeWeights.add({'type': 'Rubber', 'totalWeight': cumulativeRubber});
      cumulativeWeights.add({'type': 'Metal', 'totalWeight': cumulativeMetal});
    } catch (error) {
      print('Error retrieving cumulative weights: $error');
    }

    return cumulativeWeights;
  }
Future<List<Map<String, dynamic>>> getUserTotalWeight(String userId) async {
  List<Map<String, dynamic>> userTotalWeights = [];

  try {
    final CollectionReference recycleCollection = FirebaseFirestore.instance.collection('recycle');

    QuerySnapshot snapshot = await recycleCollection.doc(userId).collection('data').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs.map((doc) => doc as QueryDocumentSnapshot<Map<String, dynamic>>).toList();

    // Calculate the total weights for the specific user
    double totalWeight = 0;
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documents) {
      double weight = doc.get('weight') as double;
      totalWeight += weight;
    }

    userTotalWeights.add({'totalWeight': totalWeight});
  } catch (error) {
    print('Error retrieving user total weights: $error');
  }

  return userTotalWeights;
}
}