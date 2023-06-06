import 'package:cloud_firestore/cloud_firestore.dart';

class dbRecycle{
  // Collection reference
  final CollectionReference recycleCollection = FirebaseFirestore.instance.collection('recycle');

  Future<void> addRecycleData(
    String username,
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
      final DocumentReference documentRef = recycleCollection.doc(username);
      final CollectionReference newDataCollection = documentRef.collection('data');

      await newDataCollection.add({
        'username': username,
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
      QuerySnapshot snapshot = await recycleCollection.get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs.map((doc) => doc as QueryDocumentSnapshot<Map<String, dynamic>>).toList();
      print(documents);
      // Initialize the cumulative totals for each type
      double cumulativePlastic = 0;
      double cumulativeGlass = 0;
      double cumulativePaper = 0;
      double cumulativeRubber = 0;
      double cumulativeMetal = 0;

      // Calculate the cumulative weights
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documents) {
        Map<String, dynamic>? data = doc.data();

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
}