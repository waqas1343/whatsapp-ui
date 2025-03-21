// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class CustomAiChatScreen extends StatefulWidget {
//   const CustomAiChatScreen({super.key});

//   @override
//   _CustomAiChatScreenState createState() => _CustomAiChatScreenState();
// }

// class _CustomAiChatScreenState extends State<CustomAiChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   List<Map<String, dynamic>> messages = [];
//   String? selectedMedicine;
//   int? selectedDosage;
//   double? selectedPrice;
//   int selectedQuantity = 1;
//   int availableStock = 0;

//   void sendMessage() {
//     String text = _messageController.text.trim();
//     if (text.isEmpty) return;

//     setState(() {
//       messages.add({"text": text, "isUser": true});
//     });
//     _messageController.clear();

//     Future.delayed(const Duration(milliseconds: 500), () {
//       handleBotResponse(text);
//     });
//   }

//   Future<void> handleBotResponse(String text) async {
//     if (selectedMedicine == null) {
//       await checkMedicineAvailability(text);
//     } else if (selectedDosage == null) {
//       selectedDosage = int.tryParse(text);
//       if (selectedDosage != null) {
//         setState(() {
//           messages.add({
//             "text":
//                 "Aapko $selectedDosage mg dosage chahiye. Quantity select karein:",
//             "isUser": false,
//           });
//         });
//       } else {
//         setState(() {
//           messages.add({
//             "text": "Kripya sahi dosage likhein (e.g. 2, 5, 10).",
//             "isUser": false,
//           });
//         });
//       }
//     } else {
//       confirmOrder();
//     }
//   }

//   Future<void> checkMedicineAvailability(String medicineName) async {
//     var query =
//         await FirebaseFirestore.instance
//             .collection('products')
//             .where('name', isEqualTo: medicineName.trim().toLowerCase())
//             .get();

//     if (query.docs.isNotEmpty) {
//       var medicineData = query.docs.first.data();
//       setState(() {
//         selectedMedicine = medicineData['name'];
//         selectedPrice = medicineData['price'];
//         availableStock = medicineData['stock'];
//         messages.add({
//           "text":
//               "Haan! '$selectedMedicine' available hai. Aap kon si dosage chahte hain?",
//           "isUser": false,
//         });
//       });
//     } else {
//       setState(() {
//         messages.add({
//           "text": "Maaf kijiye, yeh medicine stock mein nahi hai.",
//           "isUser": false,
//         });
//       });
//     }
//   }

//   void confirmOrder() {
//     double totalPrice = selectedPrice! * selectedQuantity;
//     setState(() {
//       messages.add({
//         "text":
//             "Aapne $selectedQuantity quantity select ki hai. Total price: \$$totalPrice",
//         "isUser": false,
//       });
//       messages.add({
//         "text": "Aap kesay pay karna chahtay hain? (Cash ya Banking)",
//         "isUser": false,
//       });
//     });
//     updateStock();
//   }

//   Future<void> updateStock() async {
//     if (availableStock >= selectedQuantity) {
//       var query =
//           await FirebaseFirestore.instance
//               .collection('products')
//               .where('name', isEqualTo: selectedMedicine)
//               .get();

//       if (query.docs.isNotEmpty) {
//         var docRef = query.docs.first.reference;
//         await docRef.update({'stock': availableStock - selectedQuantity});
//       }
//       setState(() {
//         availableStock -= selectedQuantity;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("AI Chat"), centerTitle: true),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.all(2.w),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 final isUser = message['isUser'] as bool;
//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 0.5.h),
//                     padding: EdgeInsets.all(2.w),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.blue : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       message['text'] as String,
//                       style: TextStyle(
//                         color: isUser ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(2.w),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Aapka sawal yahan likhein...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.blue),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//   final String apiKey = "AIzaSyAzEhcrVkf7oa5SSeVhB5DCTT5CINKS3Qk";
//     // "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-001:generateContent?key=$apiKey",