// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Folder {
  final String name;
  final String color;
  Folder({
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'color': color,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      name: map['name'] as String,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Folder.fromJson(String source) =>
      Folder.fromMap(json.decode(source) as Map<String, dynamic>);
}
