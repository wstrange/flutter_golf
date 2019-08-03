// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<User> _$userSerializer = new _$UserSerializer();
Serializer<Profile> _$profileSerializer = new _$ProfileSerializer();
Serializer<Course> _$courseSerializer = new _$CourseSerializer();
Serializer<TeeTime> _$teeTimeSerializer = new _$TeeTimeSerializer();
Serializer<Booking> _$bookingSerializer = new _$BookingSerializer();

class _$UserSerializer implements StructuredSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];
  @override
  final String wireName = 'User';

  @override
  Iterable<Object> serialize(Serializers serializers, User object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'displayName',
      serializers.serialize(object.displayName,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  User deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'displayName':
          result.displayName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ProfileSerializer implements StructuredSerializer<Profile> {
  @override
  final Iterable<Type> types = const [Profile, _$Profile];
  @override
  final String wireName = 'Profile';

  @override
  Iterable<Object> serialize(Serializers serializers, Profile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Profile deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$CourseSerializer implements StructuredSerializer<Course> {
  @override
  final Iterable<Type> types = const [Course, _$Course];
  @override
  final String wireName = 'Course';

  @override
  Iterable<Object> serialize(Serializers serializers, Course object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Course deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CourseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$TeeTimeSerializer implements StructuredSerializer<TeeTime> {
  @override
  final Iterable<Type> types = const [TeeTime, _$TeeTime];
  @override
  final String wireName = 'TeeTime';

  @override
  Iterable<Object> serialize(Serializers serializers, TeeTime object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'dateTime',
      serializers.serialize(object.dateTime,
          specifiedType: const FullType(DateTime)),
      'courseId',
      serializers.serialize(object.courseId,
          specifiedType: const FullType(String)),
      'startingHole',
      serializers.serialize(object.startingHole,
          specifiedType: const FullType(String)),
      'availableSpots',
      serializers.serialize(object.availableSpots,
          specifiedType: const FullType(int)),
      'players',
      serializers.serialize(object.players,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(String), const FullType(User)])),
      'bookingRefs',
      serializers.serialize(object.bookingRefs,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }
    if (object.notes != null) {
      result
        ..add('notes')
        ..add(serializers.serialize(object.notes,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TeeTime deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TeeTimeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'dateTime':
          result.dateTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'courseId':
          result.courseId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'notes':
          result.notes = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'startingHole':
          result.startingHole = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'availableSpots':
          result.availableSpots = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'players':
          result.players.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(User)
              ])) as BuiltMap<dynamic, dynamic>);
          break;
        case 'bookingRefs':
          result.bookingRefs.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$BookingSerializer implements StructuredSerializer<Booking> {
  @override
  final Iterable<Type> types = const [Booking, _$Booking];
  @override
  final String wireName = 'Booking';

  @override
  Iterable<Object> serialize(Serializers serializers, Booking object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'teeTimeId',
      serializers.serialize(object.teeTimeId,
          specifiedType: const FullType(String)),
      'courseId',
      serializers.serialize(object.courseId,
          specifiedType: const FullType(String)),
      'createdByUser',
      serializers.serialize(object.createdByUser,
          specifiedType: const FullType(User)),
      'players',
      serializers.serialize(object.players,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(String), const FullType(User)])),
    ];
    if (object.paid != null) {
      result
        ..add('paid')
        ..add(serializers.serialize(object.paid,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Booking deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BookingBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'teeTimeId':
          result.teeTimeId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'courseId':
          result.courseId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdByUser':
          result.createdByUser.replace(serializers.deserialize(value,
              specifiedType: const FullType(User)) as User);
          break;
        case 'paid':
          result.paid = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'players':
          result.players.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(User)
              ])) as BuiltMap<dynamic, dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$User extends User {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String email;

  factory _$User([void Function(UserBuilder) updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._({this.id, this.displayName, this.email}) : super._() {
    if (displayName == null) {
      throw new BuiltValueNullFieldError('User', 'displayName');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('User', 'email');
    }
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        displayName == other.displayName &&
        email == other.email;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, id.hashCode), displayName.hashCode), email.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('email', email))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _displayName;
  String get displayName => _$this._displayName;
  set displayName(String displayName) => _$this._displayName = displayName;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _displayName = _$v.displayName;
      _email = _$v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    final _$result =
        _$v ?? new _$User._(id: id, displayName: displayName, email: email);
    replace(_$result);
    return _$result;
  }
}

class _$Profile extends Profile {
  @override
  final String id;

  factory _$Profile([void Function(ProfileBuilder) updates]) =>
      (new ProfileBuilder()..update(updates)).build();

  _$Profile._({this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Profile', 'id');
    }
  }

  @override
  Profile rebuild(void Function(ProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileBuilder toBuilder() => new ProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Profile && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Profile')..add('id', id)).toString();
  }
}

class ProfileBuilder implements Builder<Profile, ProfileBuilder> {
  _$Profile _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  ProfileBuilder();

  ProfileBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Profile other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Profile;
  }

  @override
  void update(void Function(ProfileBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Profile build() {
    final _$result = _$v ?? new _$Profile._(id: id);
    replace(_$result);
    return _$result;
  }
}

class _$Course extends Course {
  @override
  final String id;
  @override
  final String name;

  factory _$Course([void Function(CourseBuilder) updates]) =>
      (new CourseBuilder()..update(updates)).build();

  _$Course._({this.id, this.name}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Course', 'name');
    }
  }

  @override
  Course rebuild(void Function(CourseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CourseBuilder toBuilder() => new CourseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Course && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Course')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class CourseBuilder implements Builder<Course, CourseBuilder> {
  _$Course _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  CourseBuilder();

  CourseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Course other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Course;
  }

  @override
  void update(void Function(CourseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Course build() {
    final _$result = _$v ?? new _$Course._(id: id, name: name);
    replace(_$result);
    return _$result;
  }
}

class _$TeeTime extends TeeTime {
  @override
  final String id;
  @override
  final DateTime dateTime;
  @override
  final String courseId;
  @override
  final String notes;
  @override
  final String startingHole;
  @override
  final int availableSpots;
  @override
  final BuiltMap<String, User> players;
  @override
  final BuiltList<String> bookingRefs;

  factory _$TeeTime([void Function(TeeTimeBuilder) updates]) =>
      (new TeeTimeBuilder()..update(updates)).build();

  _$TeeTime._(
      {this.id,
      this.dateTime,
      this.courseId,
      this.notes,
      this.startingHole,
      this.availableSpots,
      this.players,
      this.bookingRefs})
      : super._() {
    if (dateTime == null) {
      throw new BuiltValueNullFieldError('TeeTime', 'dateTime');
    }
    if (courseId == null) {
      throw new BuiltValueNullFieldError('TeeTime', 'courseId');
    }
    if (startingHole == null) {
      throw new BuiltValueNullFieldError('TeeTime', 'startingHole');
    }
    if (availableSpots == null) {
      throw new BuiltValueNullFieldError('TeeTime', 'availableSpots');
    }
    if (players == null) {
      throw new BuiltValueNullFieldError('TeeTime', 'players');
    }
    if (bookingRefs == null) {
      throw new BuiltValueNullFieldError('TeeTime', 'bookingRefs');
    }
  }

  @override
  TeeTime rebuild(void Function(TeeTimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeeTimeBuilder toBuilder() => new TeeTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeeTime &&
        id == other.id &&
        dateTime == other.dateTime &&
        courseId == other.courseId &&
        notes == other.notes &&
        startingHole == other.startingHole &&
        availableSpots == other.availableSpots &&
        players == other.players &&
        bookingRefs == other.bookingRefs;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), dateTime.hashCode),
                            courseId.hashCode),
                        notes.hashCode),
                    startingHole.hashCode),
                availableSpots.hashCode),
            players.hashCode),
        bookingRefs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TeeTime')
          ..add('id', id)
          ..add('dateTime', dateTime)
          ..add('courseId', courseId)
          ..add('notes', notes)
          ..add('startingHole', startingHole)
          ..add('availableSpots', availableSpots)
          ..add('players', players)
          ..add('bookingRefs', bookingRefs))
        .toString();
  }
}

class TeeTimeBuilder implements Builder<TeeTime, TeeTimeBuilder> {
  _$TeeTime _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  DateTime _dateTime;
  DateTime get dateTime => _$this._dateTime;
  set dateTime(DateTime dateTime) => _$this._dateTime = dateTime;

  String _courseId;
  String get courseId => _$this._courseId;
  set courseId(String courseId) => _$this._courseId = courseId;

  String _notes;
  String get notes => _$this._notes;
  set notes(String notes) => _$this._notes = notes;

  String _startingHole;
  String get startingHole => _$this._startingHole;
  set startingHole(String startingHole) => _$this._startingHole = startingHole;

  int _availableSpots;
  int get availableSpots => _$this._availableSpots;
  set availableSpots(int availableSpots) =>
      _$this._availableSpots = availableSpots;

  MapBuilder<String, User> _players;
  MapBuilder<String, User> get players =>
      _$this._players ??= new MapBuilder<String, User>();
  set players(MapBuilder<String, User> players) => _$this._players = players;

  ListBuilder<String> _bookingRefs;
  ListBuilder<String> get bookingRefs =>
      _$this._bookingRefs ??= new ListBuilder<String>();
  set bookingRefs(ListBuilder<String> bookingRefs) =>
      _$this._bookingRefs = bookingRefs;

  TeeTimeBuilder();

  TeeTimeBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _dateTime = _$v.dateTime;
      _courseId = _$v.courseId;
      _notes = _$v.notes;
      _startingHole = _$v.startingHole;
      _availableSpots = _$v.availableSpots;
      _players = _$v.players?.toBuilder();
      _bookingRefs = _$v.bookingRefs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeeTime other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TeeTime;
  }

  @override
  void update(void Function(TeeTimeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TeeTime build() {
    _$TeeTime _$result;
    try {
      _$result = _$v ??
          new _$TeeTime._(
              id: id,
              dateTime: dateTime,
              courseId: courseId,
              notes: notes,
              startingHole: startingHole,
              availableSpots: availableSpots,
              players: players.build(),
              bookingRefs: bookingRefs.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'players';
        players.build();
        _$failedField = 'bookingRefs';
        bookingRefs.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TeeTime', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Booking extends Booking {
  @override
  final String id;
  @override
  final String teeTimeId;
  @override
  final String courseId;
  @override
  final User createdByUser;
  @override
  final bool paid;
  @override
  final BuiltMap<String, User> players;

  factory _$Booking([void Function(BookingBuilder) updates]) =>
      (new BookingBuilder()..update(updates)).build();

  _$Booking._(
      {this.id,
      this.teeTimeId,
      this.courseId,
      this.createdByUser,
      this.paid,
      this.players})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Booking', 'id');
    }
    if (teeTimeId == null) {
      throw new BuiltValueNullFieldError('Booking', 'teeTimeId');
    }
    if (courseId == null) {
      throw new BuiltValueNullFieldError('Booking', 'courseId');
    }
    if (createdByUser == null) {
      throw new BuiltValueNullFieldError('Booking', 'createdByUser');
    }
    if (players == null) {
      throw new BuiltValueNullFieldError('Booking', 'players');
    }
  }

  @override
  Booking rebuild(void Function(BookingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingBuilder toBuilder() => new BookingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Booking &&
        id == other.id &&
        teeTimeId == other.teeTimeId &&
        courseId == other.courseId &&
        createdByUser == other.createdByUser &&
        paid == other.paid &&
        players == other.players;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, id.hashCode), teeTimeId.hashCode),
                    courseId.hashCode),
                createdByUser.hashCode),
            paid.hashCode),
        players.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Booking')
          ..add('id', id)
          ..add('teeTimeId', teeTimeId)
          ..add('courseId', courseId)
          ..add('createdByUser', createdByUser)
          ..add('paid', paid)
          ..add('players', players))
        .toString();
  }
}

class BookingBuilder implements Builder<Booking, BookingBuilder> {
  _$Booking _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _teeTimeId;
  String get teeTimeId => _$this._teeTimeId;
  set teeTimeId(String teeTimeId) => _$this._teeTimeId = teeTimeId;

  String _courseId;
  String get courseId => _$this._courseId;
  set courseId(String courseId) => _$this._courseId = courseId;

  UserBuilder _createdByUser;
  UserBuilder get createdByUser => _$this._createdByUser ??= new UserBuilder();
  set createdByUser(UserBuilder createdByUser) =>
      _$this._createdByUser = createdByUser;

  bool _paid;
  bool get paid => _$this._paid;
  set paid(bool paid) => _$this._paid = paid;

  MapBuilder<String, User> _players;
  MapBuilder<String, User> get players =>
      _$this._players ??= new MapBuilder<String, User>();
  set players(MapBuilder<String, User> players) => _$this._players = players;

  BookingBuilder();

  BookingBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _teeTimeId = _$v.teeTimeId;
      _courseId = _$v.courseId;
      _createdByUser = _$v.createdByUser?.toBuilder();
      _paid = _$v.paid;
      _players = _$v.players?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Booking other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Booking;
  }

  @override
  void update(void Function(BookingBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Booking build() {
    _$Booking _$result;
    try {
      _$result = _$v ??
          new _$Booking._(
              id: id,
              teeTimeId: teeTimeId,
              courseId: courseId,
              createdByUser: createdByUser.build(),
              paid: paid,
              players: players.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'createdByUser';
        createdByUser.build();

        _$failedField = 'players';
        players.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Booking', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
