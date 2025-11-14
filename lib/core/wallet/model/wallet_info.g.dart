// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_info.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetWalletInfoCollection on Isar {
  IsarCollection<int, WalletInfo> get walletInfos => this.collection();
}

const WalletInfoSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'WalletInfo',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'walletId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'totalBalance',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'confirmedBalance',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'unconfirmedBalance',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'reservedBalance',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'lastUpdated',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'pubkey',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'lnbitsUrl',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'adminKey',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'invoiceKey',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'readKey',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'lnbitsUserId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'lnbitsUsername',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'totalBalanceBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'confirmedBalanceBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'unconfirmedBalanceBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'reservedBalanceBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'isEmpty',
        type: IsarType.bool,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'walletId',
        properties: [
          "walletId",
        ],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, WalletInfo>(
    serialize: serializeWalletInfo,
    deserialize: deserializeWalletInfo,
    deserializeProperty: deserializeWalletInfoProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeWalletInfo(IsarWriter writer, WalletInfo object) {
  IsarCore.writeString(writer, 1, object.walletId);
  IsarCore.writeLong(writer, 2, object.totalBalance);
  IsarCore.writeLong(writer, 3, object.confirmedBalance);
  IsarCore.writeLong(writer, 4, object.unconfirmedBalance);
  IsarCore.writeLong(writer, 5, object.reservedBalance);
  IsarCore.writeLong(writer, 6, object.lastUpdated);
  IsarCore.writeString(writer, 7, object.pubkey);
  IsarCore.writeString(writer, 8, object.lnbitsUrl);
  IsarCore.writeString(writer, 9, object.adminKey);
  IsarCore.writeString(writer, 10, object.invoiceKey);
  IsarCore.writeString(writer, 11, object.readKey);
  IsarCore.writeString(writer, 12, object.lnbitsUserId);
  IsarCore.writeString(writer, 13, object.lnbitsUsername);
  IsarCore.writeDouble(writer, 14, object.totalBalanceBTC);
  IsarCore.writeDouble(writer, 15, object.confirmedBalanceBTC);
  IsarCore.writeDouble(writer, 16, object.unconfirmedBalanceBTC);
  IsarCore.writeDouble(writer, 17, object.reservedBalanceBTC);
  IsarCore.writeBool(writer, 18, object.isEmpty);
  return object.id;
}

@isarProtected
WalletInfo deserializeWalletInfo(IsarReader reader) {
  final String _walletId;
  _walletId = IsarCore.readString(reader, 1) ?? '';
  final int _totalBalance;
  {
    final value = IsarCore.readLong(reader, 2);
    if (value == -9223372036854775808) {
      _totalBalance = 0;
    } else {
      _totalBalance = value;
    }
  }
  final int _confirmedBalance;
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      _confirmedBalance = 0;
    } else {
      _confirmedBalance = value;
    }
  }
  final int _unconfirmedBalance;
  {
    final value = IsarCore.readLong(reader, 4);
    if (value == -9223372036854775808) {
      _unconfirmedBalance = 0;
    } else {
      _unconfirmedBalance = value;
    }
  }
  final int _reservedBalance;
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      _reservedBalance = 0;
    } else {
      _reservedBalance = value;
    }
  }
  final int _lastUpdated;
  {
    final value = IsarCore.readLong(reader, 6);
    if (value == -9223372036854775808) {
      _lastUpdated = 0;
    } else {
      _lastUpdated = value;
    }
  }
  final String _pubkey;
  _pubkey = IsarCore.readString(reader, 7) ?? '';
  final String _lnbitsUrl;
  _lnbitsUrl = IsarCore.readString(reader, 8) ?? '';
  final String _adminKey;
  _adminKey = IsarCore.readString(reader, 9) ?? '';
  final String _invoiceKey;
  _invoiceKey = IsarCore.readString(reader, 10) ?? '';
  final String _readKey;
  _readKey = IsarCore.readString(reader, 11) ?? '';
  final String _lnbitsUserId;
  _lnbitsUserId = IsarCore.readString(reader, 12) ?? '';
  final String _lnbitsUsername;
  _lnbitsUsername = IsarCore.readString(reader, 13) ?? '';
  final object = WalletInfo(
    walletId: _walletId,
    totalBalance: _totalBalance,
    confirmedBalance: _confirmedBalance,
    unconfirmedBalance: _unconfirmedBalance,
    reservedBalance: _reservedBalance,
    lastUpdated: _lastUpdated,
    pubkey: _pubkey,
    lnbitsUrl: _lnbitsUrl,
    adminKey: _adminKey,
    invoiceKey: _invoiceKey,
    readKey: _readKey,
    lnbitsUserId: _lnbitsUserId,
    lnbitsUsername: _lnbitsUsername,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeWalletInfoProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      {
        final value = IsarCore.readLong(reader, 2);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 3:
      {
        final value = IsarCore.readLong(reader, 3);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 4:
      {
        final value = IsarCore.readLong(reader, 4);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 5:
      {
        final value = IsarCore.readLong(reader, 5);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 6:
      {
        final value = IsarCore.readLong(reader, 6);
        if (value == -9223372036854775808) {
          return 0;
        } else {
          return value;
        }
      }
    case 7:
      return IsarCore.readString(reader, 7) ?? '';
    case 8:
      return IsarCore.readString(reader, 8) ?? '';
    case 9:
      return IsarCore.readString(reader, 9) ?? '';
    case 10:
      return IsarCore.readString(reader, 10) ?? '';
    case 11:
      return IsarCore.readString(reader, 11) ?? '';
    case 12:
      return IsarCore.readString(reader, 12) ?? '';
    case 13:
      return IsarCore.readString(reader, 13) ?? '';
    case 14:
      return IsarCore.readDouble(reader, 14);
    case 15:
      return IsarCore.readDouble(reader, 15);
    case 16:
      return IsarCore.readDouble(reader, 16);
    case 17:
      return IsarCore.readDouble(reader, 17);
    case 18:
      return IsarCore.readBool(reader, 18);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _WalletInfoUpdate {
  bool call({
    required int id,
    String? walletId,
    int? totalBalance,
    int? confirmedBalance,
    int? unconfirmedBalance,
    int? reservedBalance,
    int? lastUpdated,
    String? pubkey,
    String? lnbitsUrl,
    String? adminKey,
    String? invoiceKey,
    String? readKey,
    String? lnbitsUserId,
    String? lnbitsUsername,
    double? totalBalanceBTC,
    double? confirmedBalanceBTC,
    double? unconfirmedBalanceBTC,
    double? reservedBalanceBTC,
    bool? isEmpty,
  });
}

class _WalletInfoUpdateImpl implements _WalletInfoUpdate {
  const _WalletInfoUpdateImpl(this.collection);

  final IsarCollection<int, WalletInfo> collection;

  @override
  bool call({
    required int id,
    Object? walletId = ignore,
    Object? totalBalance = ignore,
    Object? confirmedBalance = ignore,
    Object? unconfirmedBalance = ignore,
    Object? reservedBalance = ignore,
    Object? lastUpdated = ignore,
    Object? pubkey = ignore,
    Object? lnbitsUrl = ignore,
    Object? adminKey = ignore,
    Object? invoiceKey = ignore,
    Object? readKey = ignore,
    Object? lnbitsUserId = ignore,
    Object? lnbitsUsername = ignore,
    Object? totalBalanceBTC = ignore,
    Object? confirmedBalanceBTC = ignore,
    Object? unconfirmedBalanceBTC = ignore,
    Object? reservedBalanceBTC = ignore,
    Object? isEmpty = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (walletId != ignore) 1: walletId as String?,
          if (totalBalance != ignore) 2: totalBalance as int?,
          if (confirmedBalance != ignore) 3: confirmedBalance as int?,
          if (unconfirmedBalance != ignore) 4: unconfirmedBalance as int?,
          if (reservedBalance != ignore) 5: reservedBalance as int?,
          if (lastUpdated != ignore) 6: lastUpdated as int?,
          if (pubkey != ignore) 7: pubkey as String?,
          if (lnbitsUrl != ignore) 8: lnbitsUrl as String?,
          if (adminKey != ignore) 9: adminKey as String?,
          if (invoiceKey != ignore) 10: invoiceKey as String?,
          if (readKey != ignore) 11: readKey as String?,
          if (lnbitsUserId != ignore) 12: lnbitsUserId as String?,
          if (lnbitsUsername != ignore) 13: lnbitsUsername as String?,
          if (totalBalanceBTC != ignore) 14: totalBalanceBTC as double?,
          if (confirmedBalanceBTC != ignore) 15: confirmedBalanceBTC as double?,
          if (unconfirmedBalanceBTC != ignore)
            16: unconfirmedBalanceBTC as double?,
          if (reservedBalanceBTC != ignore) 17: reservedBalanceBTC as double?,
          if (isEmpty != ignore) 18: isEmpty as bool?,
        }) >
        0;
  }
}

sealed class _WalletInfoUpdateAll {
  int call({
    required List<int> id,
    String? walletId,
    int? totalBalance,
    int? confirmedBalance,
    int? unconfirmedBalance,
    int? reservedBalance,
    int? lastUpdated,
    String? pubkey,
    String? lnbitsUrl,
    String? adminKey,
    String? invoiceKey,
    String? readKey,
    String? lnbitsUserId,
    String? lnbitsUsername,
    double? totalBalanceBTC,
    double? confirmedBalanceBTC,
    double? unconfirmedBalanceBTC,
    double? reservedBalanceBTC,
    bool? isEmpty,
  });
}

class _WalletInfoUpdateAllImpl implements _WalletInfoUpdateAll {
  const _WalletInfoUpdateAllImpl(this.collection);

  final IsarCollection<int, WalletInfo> collection;

  @override
  int call({
    required List<int> id,
    Object? walletId = ignore,
    Object? totalBalance = ignore,
    Object? confirmedBalance = ignore,
    Object? unconfirmedBalance = ignore,
    Object? reservedBalance = ignore,
    Object? lastUpdated = ignore,
    Object? pubkey = ignore,
    Object? lnbitsUrl = ignore,
    Object? adminKey = ignore,
    Object? invoiceKey = ignore,
    Object? readKey = ignore,
    Object? lnbitsUserId = ignore,
    Object? lnbitsUsername = ignore,
    Object? totalBalanceBTC = ignore,
    Object? confirmedBalanceBTC = ignore,
    Object? unconfirmedBalanceBTC = ignore,
    Object? reservedBalanceBTC = ignore,
    Object? isEmpty = ignore,
  }) {
    return collection.updateProperties(id, {
      if (walletId != ignore) 1: walletId as String?,
      if (totalBalance != ignore) 2: totalBalance as int?,
      if (confirmedBalance != ignore) 3: confirmedBalance as int?,
      if (unconfirmedBalance != ignore) 4: unconfirmedBalance as int?,
      if (reservedBalance != ignore) 5: reservedBalance as int?,
      if (lastUpdated != ignore) 6: lastUpdated as int?,
      if (pubkey != ignore) 7: pubkey as String?,
      if (lnbitsUrl != ignore) 8: lnbitsUrl as String?,
      if (adminKey != ignore) 9: adminKey as String?,
      if (invoiceKey != ignore) 10: invoiceKey as String?,
      if (readKey != ignore) 11: readKey as String?,
      if (lnbitsUserId != ignore) 12: lnbitsUserId as String?,
      if (lnbitsUsername != ignore) 13: lnbitsUsername as String?,
      if (totalBalanceBTC != ignore) 14: totalBalanceBTC as double?,
      if (confirmedBalanceBTC != ignore) 15: confirmedBalanceBTC as double?,
      if (unconfirmedBalanceBTC != ignore) 16: unconfirmedBalanceBTC as double?,
      if (reservedBalanceBTC != ignore) 17: reservedBalanceBTC as double?,
      if (isEmpty != ignore) 18: isEmpty as bool?,
    });
  }
}

extension WalletInfoUpdate on IsarCollection<int, WalletInfo> {
  _WalletInfoUpdate get update => _WalletInfoUpdateImpl(this);

  _WalletInfoUpdateAll get updateAll => _WalletInfoUpdateAllImpl(this);
}

sealed class _WalletInfoQueryUpdate {
  int call({
    String? walletId,
    int? totalBalance,
    int? confirmedBalance,
    int? unconfirmedBalance,
    int? reservedBalance,
    int? lastUpdated,
    String? pubkey,
    String? lnbitsUrl,
    String? adminKey,
    String? invoiceKey,
    String? readKey,
    String? lnbitsUserId,
    String? lnbitsUsername,
    double? totalBalanceBTC,
    double? confirmedBalanceBTC,
    double? unconfirmedBalanceBTC,
    double? reservedBalanceBTC,
    bool? isEmpty,
  });
}

class _WalletInfoQueryUpdateImpl implements _WalletInfoQueryUpdate {
  const _WalletInfoQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<WalletInfo> query;
  final int? limit;

  @override
  int call({
    Object? walletId = ignore,
    Object? totalBalance = ignore,
    Object? confirmedBalance = ignore,
    Object? unconfirmedBalance = ignore,
    Object? reservedBalance = ignore,
    Object? lastUpdated = ignore,
    Object? pubkey = ignore,
    Object? lnbitsUrl = ignore,
    Object? adminKey = ignore,
    Object? invoiceKey = ignore,
    Object? readKey = ignore,
    Object? lnbitsUserId = ignore,
    Object? lnbitsUsername = ignore,
    Object? totalBalanceBTC = ignore,
    Object? confirmedBalanceBTC = ignore,
    Object? unconfirmedBalanceBTC = ignore,
    Object? reservedBalanceBTC = ignore,
    Object? isEmpty = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (walletId != ignore) 1: walletId as String?,
      if (totalBalance != ignore) 2: totalBalance as int?,
      if (confirmedBalance != ignore) 3: confirmedBalance as int?,
      if (unconfirmedBalance != ignore) 4: unconfirmedBalance as int?,
      if (reservedBalance != ignore) 5: reservedBalance as int?,
      if (lastUpdated != ignore) 6: lastUpdated as int?,
      if (pubkey != ignore) 7: pubkey as String?,
      if (lnbitsUrl != ignore) 8: lnbitsUrl as String?,
      if (adminKey != ignore) 9: adminKey as String?,
      if (invoiceKey != ignore) 10: invoiceKey as String?,
      if (readKey != ignore) 11: readKey as String?,
      if (lnbitsUserId != ignore) 12: lnbitsUserId as String?,
      if (lnbitsUsername != ignore) 13: lnbitsUsername as String?,
      if (totalBalanceBTC != ignore) 14: totalBalanceBTC as double?,
      if (confirmedBalanceBTC != ignore) 15: confirmedBalanceBTC as double?,
      if (unconfirmedBalanceBTC != ignore) 16: unconfirmedBalanceBTC as double?,
      if (reservedBalanceBTC != ignore) 17: reservedBalanceBTC as double?,
      if (isEmpty != ignore) 18: isEmpty as bool?,
    });
  }
}

extension WalletInfoQueryUpdate on IsarQuery<WalletInfo> {
  _WalletInfoQueryUpdate get updateFirst =>
      _WalletInfoQueryUpdateImpl(this, limit: 1);

  _WalletInfoQueryUpdate get updateAll => _WalletInfoQueryUpdateImpl(this);
}

class _WalletInfoQueryBuilderUpdateImpl implements _WalletInfoQueryUpdate {
  const _WalletInfoQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<WalletInfo, WalletInfo, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? walletId = ignore,
    Object? totalBalance = ignore,
    Object? confirmedBalance = ignore,
    Object? unconfirmedBalance = ignore,
    Object? reservedBalance = ignore,
    Object? lastUpdated = ignore,
    Object? pubkey = ignore,
    Object? lnbitsUrl = ignore,
    Object? adminKey = ignore,
    Object? invoiceKey = ignore,
    Object? readKey = ignore,
    Object? lnbitsUserId = ignore,
    Object? lnbitsUsername = ignore,
    Object? totalBalanceBTC = ignore,
    Object? confirmedBalanceBTC = ignore,
    Object? unconfirmedBalanceBTC = ignore,
    Object? reservedBalanceBTC = ignore,
    Object? isEmpty = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (walletId != ignore) 1: walletId as String?,
        if (totalBalance != ignore) 2: totalBalance as int?,
        if (confirmedBalance != ignore) 3: confirmedBalance as int?,
        if (unconfirmedBalance != ignore) 4: unconfirmedBalance as int?,
        if (reservedBalance != ignore) 5: reservedBalance as int?,
        if (lastUpdated != ignore) 6: lastUpdated as int?,
        if (pubkey != ignore) 7: pubkey as String?,
        if (lnbitsUrl != ignore) 8: lnbitsUrl as String?,
        if (adminKey != ignore) 9: adminKey as String?,
        if (invoiceKey != ignore) 10: invoiceKey as String?,
        if (readKey != ignore) 11: readKey as String?,
        if (lnbitsUserId != ignore) 12: lnbitsUserId as String?,
        if (lnbitsUsername != ignore) 13: lnbitsUsername as String?,
        if (totalBalanceBTC != ignore) 14: totalBalanceBTC as double?,
        if (confirmedBalanceBTC != ignore) 15: confirmedBalanceBTC as double?,
        if (unconfirmedBalanceBTC != ignore)
          16: unconfirmedBalanceBTC as double?,
        if (reservedBalanceBTC != ignore) 17: reservedBalanceBTC as double?,
        if (isEmpty != ignore) 18: isEmpty as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension WalletInfoQueryBuilderUpdate
    on QueryBuilder<WalletInfo, WalletInfo, QOperations> {
  _WalletInfoQueryUpdate get updateFirst =>
      _WalletInfoQueryBuilderUpdateImpl(this, limit: 1);

  _WalletInfoQueryUpdate get updateAll =>
      _WalletInfoQueryBuilderUpdateImpl(this);
}

extension WalletInfoQueryFilter
    on QueryBuilder<WalletInfo, WalletInfo, QFilterCondition> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      pubkeyGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      pubkeyLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      pubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 8,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 9,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 9,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 9,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 9,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> invoiceKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> invoiceKeyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> invoiceKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 10,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      readKeyGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      readKeyGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      readKeyLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 11,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      readKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 12,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 13,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 13,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 14,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 14,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 14,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 14,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 14,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 14,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 15,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 15,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 15,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 15,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 15,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 15,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 16,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 17,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> isEmptyEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }
}

extension WalletInfoQueryObject
    on QueryBuilder<WalletInfo, WalletInfo, QFilterCondition> {}

extension WalletInfoQuerySortBy
    on QueryBuilder<WalletInfo, WalletInfo, QSortBy> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByWalletIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByTotalBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByConfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByReservedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByPubkeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUrlDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByAdminKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        9,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByAdminKeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        9,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByInvoiceKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByInvoiceKeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByReadKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByReadKeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUserIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUsernameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByTotalBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByConfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByReservedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByIsEmptyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }
}

extension WalletInfoQuerySortThenBy
    on QueryBuilder<WalletInfo, WalletInfo, QSortThenBy> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByWalletIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByTotalBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByConfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByReservedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByPubkeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUrlDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByAdminKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByAdminKeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByInvoiceKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByInvoiceKeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByReadKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByReadKeyDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUserIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUsernameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByTotalBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByConfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByReservedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByIsEmptyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }
}

extension WalletInfoQueryWhereDistinct
    on QueryBuilder<WalletInfo, WalletInfo, QDistinct> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByLnbitsUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByAdminKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByInvoiceKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByReadKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByLnbitsUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByLnbitsUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct>
      distinctByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterDistinct> distinctByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }
}

extension WalletInfoQueryProperty1
    on QueryBuilder<WalletInfo, WalletInfo, QProperty> {
  QueryBuilder<WalletInfo, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletInfo, int, QAfterProperty> totalBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletInfo, int, QAfterProperty> confirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletInfo, int, QAfterProperty> unconfirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletInfo, int, QAfterProperty> reservedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletInfo, int, QAfterProperty> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> lnbitsUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> adminKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> invoiceKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> readKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> lnbitsUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletInfo, String, QAfterProperty> lnbitsUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletInfo, double, QAfterProperty> totalBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletInfo, double, QAfterProperty>
      confirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletInfo, double, QAfterProperty>
      unconfirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletInfo, double, QAfterProperty>
      reservedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletInfo, bool, QAfterProperty> isEmptyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }
}

extension WalletInfoQueryProperty2<R>
    on QueryBuilder<WalletInfo, R, QAfterProperty> {
  QueryBuilder<WalletInfo, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletInfo, (R, int), QAfterProperty> totalBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletInfo, (R, int), QAfterProperty>
      confirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletInfo, (R, int), QAfterProperty>
      unconfirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletInfo, (R, int), QAfterProperty> reservedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletInfo, (R, int), QAfterProperty> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty> lnbitsUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty> adminKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty> invoiceKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty> readKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty> lnbitsUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletInfo, (R, String), QAfterProperty>
      lnbitsUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletInfo, (R, double), QAfterProperty>
      totalBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletInfo, (R, double), QAfterProperty>
      confirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletInfo, (R, double), QAfterProperty>
      unconfirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletInfo, (R, double), QAfterProperty>
      reservedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletInfo, (R, bool), QAfterProperty> isEmptyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }
}

extension WalletInfoQueryProperty3<R1, R2>
    on QueryBuilder<WalletInfo, (R1, R2), QAfterProperty> {
  QueryBuilder<WalletInfo, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, int), QOperations> totalBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, int), QOperations>
      confirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, int), QOperations>
      unconfirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, int), QOperations>
      reservedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, int), QOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations> lnbitsUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations> adminKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations> invoiceKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations> readKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations>
      lnbitsUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, String), QOperations>
      lnbitsUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, double), QOperations>
      totalBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, double), QOperations>
      confirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, double), QOperations>
      unconfirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, double), QOperations>
      reservedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletInfo, (R1, R2, bool), QOperations> isEmptyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }
}
