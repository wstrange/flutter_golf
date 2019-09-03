///
//  Generated code. Do not modify.
//  source: golf.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $0;

class TeeTime extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TeeTime', package: const $pb.PackageName('golf_model'))
    ..aOS(1, 'notes')
    ..a<$core.int>(2, 'numberPlayers', $pb.PbFieldType.O3)
    ..a<$0.Timestamp>(3, 'timeStamp', $pb.PbFieldType.OM, $0.Timestamp.getDefault, $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  TeeTime._() : super();
  factory TeeTime() => create();
  factory TeeTime.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TeeTime.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TeeTime clone() => TeeTime()..mergeFromMessage(this);
  TeeTime copyWith(void Function(TeeTime) updates) => super.copyWith((message) => updates(message as TeeTime));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TeeTime create() => TeeTime._();
  TeeTime createEmptyInstance() => create();
  static $pb.PbList<TeeTime> createRepeated() => $pb.PbList<TeeTime>();
  static TeeTime getDefault() => _defaultInstance ??= create()..freeze();
  static TeeTime _defaultInstance;

  $core.String get notes => $_getS(0, '');
  set notes($core.String v) { $_setString(0, v); }
  $core.bool hasNotes() => $_has(0);
  void clearNotes() => clearField(1);

  $core.int get numberPlayers => $_get(1, 0);
  set numberPlayers($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasNumberPlayers() => $_has(1);
  void clearNumberPlayers() => clearField(2);

  $0.Timestamp get timeStamp => $_getN(2);
  set timeStamp($0.Timestamp v) { setField(3, v); }
  $core.bool hasTimeStamp() => $_has(2);
  void clearTimeStamp() => clearField(3);
}

