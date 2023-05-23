import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:studie/constants/default_values.dart';
import 'package:studie/models/flashcard.dart';
import 'package:studie/models/folder.dart';
import 'package:studie/models/message.dart';
import 'package:studie/models/note.dart';
import 'package:studie/models/room.dart';
import 'package:studie/models/user.dart';
import 'package:studie/services/auth_methods.dart';

class DBMethods {
  final _db = FirebaseFirestore.instance;
  final _authMethods = AuthMethods();

  Stream<QuerySnapshot> getMessages(String roomId) {
    final snapshots = _db
        .collection("rooms")
        .doc(roomId)
        .collection('messages')
        .orderBy("createdAt", descending: true)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getNotes() {
    final userId = _authMethods.user!.uid;
    final snapshots = _db
        .collection("users")
        .doc(userId)
        .collection("notes")
        .orderBy("lastEdit", descending: true)
        .snapshots();
    return snapshots;
  }

  Future<QuerySnapshot> getFolders() async {
    final userId = _authMethods.user!.uid;
    final snapshots =
        await _db.collection("users").doc(userId).collection("folders").get();
    return snapshots;
  }

  Stream<QuerySnapshot> getFoldersNotes(String folderName) {
    final userId = _authMethods.user!.uid;
    final snapshots = _db
        .collection("users")
        .doc(userId)
        .collection("notes")
        .where("folderName", isEqualTo: folderName)
        .orderBy("lastEdit", descending: true)
        .snapshots();
    return snapshots;
  }

  Future<void> editNote(
      String noteId, String newColor, String newFolder) async {
    final userId = _authMethods.user!.uid;
    await _db
        .collection("users")
        .doc(userId)
        .collection("notes")
        .doc(noteId)
        .update({"color": newColor, "folderName": newFolder});
  }

  Future<void> createFolder(String name, String color) async {
    final userId = _authMethods.user!.uid;
    await _db
        .collection("users")
        .doc(userId)
        .collection("folders")
        .add({"name": name, "color": color});
  }

  Future<void> sendMessage(String message, String roomId) async {
    try {
      final curUser = _authMethods.user;
      if (curUser == null) return;

      final messageObj = Message(
        id: '',
        senderId: curUser.uid,
        senderName: curUser.displayName ?? kDefaultName,
        senderPhotoURL: curUser.photoURL ?? "",
        text: message,
        createdAt: DateTime.now().toString(),
      );

      final docRef = await _db
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .add(messageObj.toJson());
      docRef.update({"id": docRef.id});
    } catch (e) {
      debugPrint('error sending message: $e');
    }
  }

  Future<void> addUserToDB(User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        "uid": user.uid,
        "username": user.displayName ?? kDefaultName,
        "photoURL": user.photoURL ?? "",
        "email": user.email ?? "",
      });

      debugPrint('added user to db');
    } catch (e) {
      debugPrint('error adding user to db: $e');
    }
  }

  Stream<QuerySnapshot> getRooms() {
    return _db
        .collection('rooms')
        .orderBy("maxParticipants", descending: true)
        .snapshots();
  }

  Future<bool> createRoom(Room room) async {
    bool created = true;
    try {
      final docRef = await _db.collection('rooms').add(room.toJson());
      room.copyWith(docRef.id);
      docRef.update({"id": docRef.id});

      debugPrint('room created!');
    } catch (e) {
      created = false;
      debugPrint('error creating room: $e');
      created = false;
    }
    return created;
  }

  Future<String> joinRoom(String roomId) async {
    String result = "success";
    try {
      final user = UserModel.fromFirebaseUser(_authMethods.user!);
      final roomRef = _db.collection('rooms').doc(roomId);
      final roomSnapshot = await roomRef.get();
      final room = Room.fromJson(roomSnapshot.data() as Map<String, dynamic>);

      if (room.curParticipants >= room.maxParticipants) {
        return result = "Phòng học đã đầy!";
      }

      roomRef.collection('participants').doc(user.uid).set(user.toJson());
      roomRef.update({"curParticipants": FieldValue.increment(1)});

      debugPrint('joined room with id:  $roomId');
    } catch (e) {
      result = "Đã có lỗi xảy ra khi vào phòng học!";
      debugPrint('error joining room $e');
    }

    return result;
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      final user = _authMethods.user;
      final currentRoomIn = _db.collection('rooms').doc(roomId);
      currentRoomIn.collection('participants').doc(user!.uid).delete();

      final curParticipants =
          (await currentRoomIn.get()).data()!["curParticipants"];
      if (curParticipants == 1) {
        currentRoomIn.delete();
      } else {
        currentRoomIn.update({"curParticipants": FieldValue.increment(-1)});
      }

      debugPrint('left room !');
    } catch (e) {
      debugPrint('error leaving room: $e');
    }
  }

  Future<String> putNoteToDB(Note note) async {
    String res = "success";

    try {
      final userId = _authMethods.user!.uid;
      final ref = _db.collection("users").doc(userId).collection("notes");
      final docRef = await ref.add(note.toJson());
      await docRef.update({"id": docRef.id});
      note.copyWith(newId: docRef.id);
    } catch (e) {
      res = "Lỗi tạo ghi chú mới";
    }

    return res;
  }

  Future<String> updateNote(String noteId, Note newNote) async {
    String res = "success";

    try {
      final userId = _authMethods.user!.uid;
      final ref =
          _db.collection("users").doc(userId).collection("notes").doc(noteId);
      await ref.set(newNote.toJson());
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> deleteAllFlashcards(String noteId) async {
    try {
      final userId = _authMethods.user!.uid;
      final noteRef =
          _db.collection("users").doc(userId).collection("notes").doc(noteId);
      final flashcardsRef = noteRef.collection("flashcards");
      final flashcards = await flashcardsRef.get();
      for (final card in flashcards.docs) {
        await flashcardsRef.doc(card.id).delete();
      }
    } catch (e) {
      debugPrint("error delete the flashcards: $e");
    }
  }

  Future<String> putFlashcardToNote(String noteId, Flashcard flashcard) async {
    String res = "success";
    try {
      final userId = _authMethods.user!.uid;
      final noteRef =
          _db.collection("users").doc(userId).collection("notes").doc(noteId);

      final docRef =
          await noteRef.collection("flashcards").add(flashcard.toJson());
      flashcard.copyWith(docRef.id);
      docRef.update({"id": docRef.id});
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<QuerySnapshot> getFlashcardsFromNote(String noteId) async {
    final userId = _authMethods.user!.uid;
    final ref =
        _db.collection("users").doc(userId).collection("notes").doc(noteId);
    final flashcards = await ref.collection("flashcards").get();
    return flashcards;
  }

  Future<DocumentSnapshot> getSharedNote(String userId, String noteId) async {
    final ref =
        _db.collection("users").doc(userId).collection("notes").doc(noteId);
    final note = await ref.get();
    return note;
  }

  Future<String> shareDocumentWithRoom(Note note, String roomId) async {
    String res = "success";

    try {
      final user = _authMethods.user!;
      final roomRef = _db.collection("rooms").doc(roomId);
      final message = Message(
        id: "",
        senderId: user.uid,
        senderName: user.displayName ?? kDefaultName,
        senderPhotoURL: user.photoURL ?? "",
        text: note.id,
        createdAt: DateTime.now().toString(),
        type: "document_share",
      );
      final msgRef = await roomRef.collection("messages").add(message.toJson());
      msgRef.update({"id": msgRef.id});
    } catch (e) {
      res = "error sharing doc: $e";
    }

    return res;
  }

  Future<void> updateMaxParticipants(
    BuildContext context,
    String roomId,
    int curVal,
    int curMax,
    int newMax,
  ) async {
    try {
      final room = _db.collection("rooms").doc(roomId);
      if (newMax >= curVal && newMax != curMax) {
        await room.update({"maxParticipants": newMax});
      }
    } catch (e) {
      print("[updateMaxParticipants]: $e");
    }
  }
}
