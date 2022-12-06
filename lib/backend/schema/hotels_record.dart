import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'hotels_record.g.dart';

abstract class HotelsRecord
    implements Built<HotelsRecord, HotelsRecordBuilder> {
  static Serializer<HotelsRecord> get serializer => _$hotelsRecordSerializer;

  String? get name;

  String? get description;

  String? get city;

  int? get review;

  String? get image;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(HotelsRecordBuilder builder) => builder
    ..name = ''
    ..description = ''
    ..city = ''
    ..review = 0
    ..image = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Hotels');

  static Stream<HotelsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<HotelsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  HotelsRecord._();
  factory HotelsRecord([void Function(HotelsRecordBuilder) updates]) =
      _$HotelsRecord;

  static HotelsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createHotelsRecordData({
  String? name,
  String? description,
  String? city,
  int? review,
  String? image,
}) {
  final firestoreData = serializers.toFirestore(
    HotelsRecord.serializer,
    HotelsRecord(
      (h) => h
        ..name = name
        ..description = description
        ..city = city
        ..review = review
        ..image = image,
    ),
  );

  return firestoreData;
}
