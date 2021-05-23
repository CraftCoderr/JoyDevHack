// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

// class UserAc {
//   String firstName;
//   String lastName;
//   String avatarUrl;
//   UserAc(this.firstName, this.lastName, this.avatarUrl);
// }

// class AccountPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class AccountNote extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _AccountNote();
//   }
// }

// class _AccountNote extends State<AccountNote> {
//   types.User? userSelf;
//   bool isEditing = false;
//   bool isAvatarEdited = false;
//   late String newAvatarPath;

//   final _formKey = GlobalKey<FormState>();
//   late String _firstName;
//   late String _lastName;

//   final _editingTextStyle = const TextStyle(
//     fontSize: 18,
//     color: Colors.blueAccent,
//   );

//   InputDecoration inputDecor(String labelText) {
//     return InputDecoration(
//       labelText: labelText,
//       labelStyle: const TextStyle(
//         color: Colors.blueAccent,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(25.0),
//         borderSide: const BorderSide(
//           color: Colors.grey,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(25.0),
//         borderSide: const BorderSide(
//           color: Colors.blueAccent,
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(25.0),
//         borderSide: const BorderSide(
//           color: Colors.red,
//         ),
//       ),
//     );
//   }

//   Widget textButton(
//     String text, {
//     void Function()? onTap = null,
//     bool border = false,
//     Color buttonColor = Colors.transparent,
//     Color borderColor = Colors.black54,
//     Color fontColor = Colors.black,
//     String fontFamily = 'Montserrat_Regular',
//     double borderRadius = 90.0,
//     double? width = null,
//     double fontSize = 18,
//     double paddingVertical = 8.0,
//     double paddingHorizontal = 30.0,
//     bool showIcon = false,
//     IconData iconData = Icons.done,
//     Color iconColor = Colors.black,
//     double verticalDividerWidth = 5.0,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.all(
//         Radius.circular(borderRadius),
//       ),
//       splashColor: borderColor.withOpacity(0.1),
//       highlightColor: borderColor.withOpacity(0.2),
//       onTap: onTap,
//       child: Container(
//         width: width,
//         padding: EdgeInsets.symmetric(
//           vertical: paddingVertical,
//           horizontal: paddingHorizontal,
//         ),
//         decoration: BoxDecoration(
//           color: buttonColor,
//           border: border
//               ? Border.all(
//                   color: borderColor,
//                 )
//               : null,
//           borderRadius: BorderRadius.all(
//             Radius.circular(borderRadius),
//           ),
//         ),
//         child: !showIcon
//             ? Text(
//                 text,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: fontColor,
//                   fontSize: fontSize,
//                   fontFamily: fontFamily,
//                 ),
//               )
//             : Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Icon(
//                     iconData,
//                     size: fontSize * 1.05,
//                     color: iconColor,
//                   ),
//                   VerticalDivider(
//                     width: verticalDividerWidth,
//                     color: Colors.transparent,
//                   ),
//                   Text(
//                     text,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: fontColor,
//                       fontSize: fontSize,
//                       fontFamily: fontFamily,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   _AccountNote({this.userSelf});

//   Widget _info(String title, IconData iconData) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Row(
//         children: <Widget>[
//           Icon(
//             iconData,
//             color: Colors.grey,
//             size: 26,
//           ),
//           const VerticalDivider(width: 30),
//           Text(
//             title,
//             style: _editingTextStyle,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return userSelf == null
//         ? const Center(child: CircularProgressIndicator())
//         : SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(top: 35.0),
//                       width: 180,
//                       height: 180,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: (isAvatarEdited
//                                   ? FileImage(File(newAvatarPath))
//                                   : NetworkImage(userSelf!.avatarUrl!))
//                               as ImageProvider<Object>,
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           const BoxShadow(
//                             color: Colors.black38,
//                             blurRadius: 7.0,
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(3.0),
//                       ),
//                       child: isEditing
//                           ? InkWell(
//                               child: IconButton(
//                                 icon: const Icon(Icons.edit),
//                                 onPressed: () {
//                                   WidgetsBinding.instance!.addPostFrameCallback(
//                                     (_) async {
//                                       // newAvatarPath =
//                                       //     await SelfMemberActions.uploadAvatarImage();
//                                       setState(() {
//                                         isAvatarEdited = true;
//                                       });
//                                     },
//                                   );
//                                 },
//                               ),
//                             )
//                           : Container(),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.only(top: 25.0),
//                         child: isEditing
//                             ? textButton(
//                                 'Завершить',
//                                 buttonColor: Colors.blueAccent,
//                                 fontColor: Colors.white,
//                                 showIcon: true,
//                                 iconData: Icons.check_rounded,
//                                 iconColor: Colors.white,
//                                 onTap: () async {
//                                   // if (_formKey.currentState!.validate()) {
//                                   //   if (userSelf!.firstName != _firstName ||
//                                   //       userSelf!.lastName != _lastName) {
//                                   //     userSelf!.firstName = _firstName;
//                                   //     userSelf!.lastName = _lastName;
//                                   //     await SelfMemberActions.uploadInfo(
//                                   //         _firstName, _lastName);
//                                   //   }
//                                   // }
//                                   setState(() {
//                                     isEditing = false;
//                                   });
//                                   // MemoryImage(),
//                                 },
//                               )
//                             : textButton(
//                                 'Редактирвоать',
//                                 buttonColor: Colors.blueAccent,
//                                 fontColor: Colors.white,
//                                 showIcon: true,
//                                 iconData: Icons.edit,
//                                 iconColor: Colors.white,
//                                 onTap: () {
//                                   setState(() {
//                                     isEditing = true;
//                                   });
//                                 },
//                               )),
//                     const Divider(
//                       height: 50,
//                       color: Colors.transparent,
//                     ),
//                     if (isEditing)
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: <Widget>[
//                             TextFormField(
//                               initialValue: userSelf!.firstName!,
//                               maxLength: 30,
//                               style: _editingTextStyle,
//                               decoration: inputDecor('Имя'),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Поле должно быть заполнено';
//                                 } else {
//                                   _firstName = value;
//                                   return null;
//                                 }
//                               },
//                             ),
//                             const Divider(
//                                 color: Colors.transparent, height: 15.0),
//                             TextFormField(
//                               initialValue: userSelf!.lastName!,
//                               maxLength: 30,
//                               style: _editingTextStyle,
//                               decoration: inputDecor('Фамилия'),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Поле должно быть заполнено';
//                                 } else {
//                                   _lastName = value;
//                                   return null;
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       )
//                     else
//                       _info(userSelf!.firstName! + " " + userSelf!.lastName!,
//                           Icons.account_box_rounded),
//                     const Divider(height: 38),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }
// }
