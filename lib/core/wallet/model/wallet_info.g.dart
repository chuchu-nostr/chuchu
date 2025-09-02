// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_info.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalletInfoCollection on Isar {
  IsarCollection<WalletInfo> get walletInfos => this.collection();
}

const WalletInfoSchema = CollectionSchema(
  name: r'WalletInfo',
  id: -2861501434900022153,
  properties: {
    r'adminKey': PropertySchema(
      id: 0,
      name: r'adminKey',
      type: IsarType.string,
    ),
    r'confirmedBalance': PropertySchema(
      id: 1,
      name: r'confirmedBalance',
      type: IsarType.long,
    ),
    r'confirmedBalanceBTC': PropertySchema(
      id: 2,
      name: r'confirmedBalanceBTC',
      type: IsarType.double,
    ),
    r'hashCode': PropertySchema(
      id: 3,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'invoiceKey': PropertySchema(
      id: 4,
      name: r'invoiceKey',
      type: IsarType.string,
    ),
    r'isEmpty': PropertySchema(
      id: 5,
      name: r'isEmpty',
      type: IsarType.bool,
    ),
    r'lastUpdated': PropertySchema(
      id: 6,
      name: r'lastUpdated',
      type: IsarType.long,
    ),
    r'lnbitsUrl': PropertySchema(
      id: 7,
      name: r'lnbitsUrl',
      type: IsarType.string,
    ),
    r'lnbitsUserId': PropertySchema(
      id: 8,
      name: r'lnbitsUserId',
      type: IsarType.string,
    ),
    r'lnbitsUsername': PropertySchema(
      id: 9,
      name: r'lnbitsUsername',
      type: IsarType.string,
    ),
    r'pubkey': PropertySchema(
      id: 10,
      name: r'pubkey',
      type: IsarType.string,
    ),
    r'readKey': PropertySchema(
      id: 11,
      name: r'readKey',
      type: IsarType.string,
    ),
    r'reservedBalance': PropertySchema(
      id: 12,
      name: r'reservedBalance',
      type: IsarType.long,
    ),
    r'reservedBalanceBTC': PropertySchema(
      id: 13,
      name: r'reservedBalanceBTC',
      type: IsarType.double,
    ),
    r'totalBalance': PropertySchema(
      id: 14,
      name: r'totalBalance',
      type: IsarType.long,
    ),
    r'totalBalanceBTC': PropertySchema(
      id: 15,
      name: r'totalBalanceBTC',
      type: IsarType.double,
    ),
    r'unconfirmedBalance': PropertySchema(
      id: 16,
      name: r'unconfirmedBalance',
      type: IsarType.long,
    ),
    r'unconfirmedBalanceBTC': PropertySchema(
      id: 17,
      name: r'unconfirmedBalanceBTC',
      type: IsarType.double,
    ),
    r'walletId': PropertySchema(
      id: 18,
      name: r'walletId',
      type: IsarType.string,
    )
  },
  estimateSize: _walletInfoEstimateSize,
  serialize: _walletInfoSerialize,
  deserialize: _walletInfoDeserialize,
  deserializeProp: _walletInfoDeserializeProp,
  idName: r'id',
  indexes: {
    r'walletId': IndexSchema(
      id: -1783113319798776304,
      name: r'walletId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'walletId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _walletInfoGetId,
  getLinks: _walletInfoGetLinks,
  attach: _walletInfoAttach,
  version: '3.1.0+1',
);

int _walletInfoEstimateSize(
  WalletInfo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.adminKey.length * 3;
  bytesCount += 3 + object.invoiceKey.length * 3;
  bytesCount += 3 + object.lnbitsUrl.length * 3;
  bytesCount += 3 + object.lnbitsUserId.length * 3;
  bytesCount += 3 + object.lnbitsUsername.length * 3;
  bytesCount += 3 + object.pubkey.length * 3;
  bytesCount += 3 + object.readKey.length * 3;
  bytesCount += 3 + object.walletId.length * 3;
  return bytesCount;
}

void _walletInfoSerialize(
  WalletInfo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.adminKey);
  writer.writeLong(offsets[1], object.confirmedBalance);
  writer.writeDouble(offsets[2], object.confirmedBalanceBTC);
  writer.writeLong(offsets[3], object.hashCode);
  writer.writeString(offsets[4], object.invoiceKey);
  writer.writeBool(offsets[5], object.isEmpty);
  writer.writeLong(offsets[6], object.lastUpdated);
  writer.writeString(offsets[7], object.lnbitsUrl);
  writer.writeString(offsets[8], object.lnbitsUserId);
  writer.writeString(offsets[9], object.lnbitsUsername);
  writer.writeString(offsets[10], object.pubkey);
  writer.writeString(offsets[11], object.readKey);
  writer.writeLong(offsets[12], object.reservedBalance);
  writer.writeDouble(offsets[13], object.reservedBalanceBTC);
  writer.writeLong(offsets[14], object.totalBalance);
  writer.writeDouble(offsets[15], object.totalBalanceBTC);
  writer.writeLong(offsets[16], object.unconfirmedBalance);
  writer.writeDouble(offsets[17], object.unconfirmedBalanceBTC);
  writer.writeString(offsets[18], object.walletId);
}

WalletInfo _walletInfoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalletInfo(
    adminKey: reader.readStringOrNull(offsets[0]) ?? '',
    confirmedBalance: reader.readLongOrNull(offsets[1]) ?? 0,
    invoiceKey: reader.readStringOrNull(offsets[4]) ?? '',
    lastUpdated: reader.readLongOrNull(offsets[6]) ?? 0,
    lnbitsUrl: reader.readStringOrNull(offsets[7]) ?? '',
    lnbitsUserId: reader.readStringOrNull(offsets[8]) ?? '',
    lnbitsUsername: reader.readStringOrNull(offsets[9]) ?? '',
    pubkey: reader.readStringOrNull(offsets[10]) ?? '',
    readKey: reader.readStringOrNull(offsets[11]) ?? '',
    reservedBalance: reader.readLongOrNull(offsets[12]) ?? 0,
    totalBalance: reader.readLongOrNull(offsets[14]) ?? 0,
    unconfirmedBalance: reader.readLongOrNull(offsets[16]) ?? 0,
    walletId: reader.readStringOrNull(offsets[18]) ?? '',
  );
  object.id = id;
  return object;
}

P _walletInfoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 10:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 11:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 12:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _walletInfoGetId(WalletInfo object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletInfoGetLinks(WalletInfo object) {
  return [];
}

void _walletInfoAttach(IsarCollection<dynamic> col, Id id, WalletInfo object) {
  object.id = id;
}

extension WalletInfoByIndex on IsarCollection<WalletInfo> {
  Future<WalletInfo?> getByWalletId(String walletId) {
    return getByIndex(r'walletId', [walletId]);
  }

  WalletInfo? getByWalletIdSync(String walletId) {
    return getByIndexSync(r'walletId', [walletId]);
  }

  Future<bool> deleteByWalletId(String walletId) {
    return deleteByIndex(r'walletId', [walletId]);
  }

  bool deleteByWalletIdSync(String walletId) {
    return deleteByIndexSync(r'walletId', [walletId]);
  }

  Future<List<WalletInfo?>> getAllByWalletId(List<String> walletIdValues) {
    final values = walletIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'walletId', values);
  }

  List<WalletInfo?> getAllByWalletIdSync(List<String> walletIdValues) {
    final values = walletIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'walletId', values);
  }

  Future<int> deleteAllByWalletId(List<String> walletIdValues) {
    final values = walletIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'walletId', values);
  }

  int deleteAllByWalletIdSync(List<String> walletIdValues) {
    final values = walletIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'walletId', values);
  }

  Future<Id> putByWalletId(WalletInfo object) {
    return putByIndex(r'walletId', object);
  }

  Id putByWalletIdSync(WalletInfo object, {bool saveLinks = true}) {
    return putByIndexSync(r'walletId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWalletId(List<WalletInfo> objects) {
    return putAllByIndex(r'walletId', objects);
  }

  List<Id> putAllByWalletIdSync(List<WalletInfo> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'walletId', objects, saveLinks: saveLinks);
  }
}

extension WalletInfoQueryWhereSort
    on QueryBuilder<WalletInfo, WalletInfo, QWhere> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletInfoQueryWhere
    on QueryBuilder<WalletInfo, WalletInfo, QWhereClause> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterWhereClause> walletIdEqualTo(
      String walletId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'walletId',
        value: [walletId],
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterWhereClause> walletIdNotEqualTo(
      String walletId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'walletId',
              lower: [],
              upper: [walletId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'walletId',
              lower: [walletId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'walletId',
              lower: [walletId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'walletId',
              lower: [],
              upper: [walletId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WalletInfoQueryFilter
    on QueryBuilder<WalletInfo, WalletInfo, QFilterCondition> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adminKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adminKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adminKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'adminKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'adminKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adminKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> adminKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adminKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      adminKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'adminKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confirmedBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confirmedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confirmedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      confirmedBalanceBTCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confirmedBalanceBTC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> invoiceKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoiceKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoiceKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> invoiceKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoiceKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invoiceKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invoiceKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoiceKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> invoiceKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoiceKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      invoiceKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoiceKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> isEmptyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEmpty',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lastUpdatedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnbitsUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lnbitsUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lnbitsUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lnbitsUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lnbitsUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lnbitsUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lnbitsUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> lnbitsUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lnbitsUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnbitsUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lnbitsUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnbitsUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lnbitsUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lnbitsUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lnbitsUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lnbitsUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lnbitsUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lnbitsUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lnbitsUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnbitsUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lnbitsUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnbitsUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lnbitsUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lnbitsUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lnbitsUsername',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lnbitsUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lnbitsUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lnbitsUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lnbitsUsername',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnbitsUsername',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      lnbitsUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lnbitsUsername',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> pubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      pubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      readKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'readKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'readKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'readKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'readKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> readKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      readKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'readKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reservedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reservedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reservedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reservedBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reservedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reservedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reservedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      reservedBalanceBTCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reservedBalanceBTC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      totalBalanceBTCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBalanceBTC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unconfirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unconfirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unconfirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unconfirmedBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unconfirmedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unconfirmedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unconfirmedBalanceBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      unconfirmedBalanceBTCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unconfirmedBalanceBTC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'walletId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition> walletIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'walletId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterFilterCondition>
      walletIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'walletId',
        value: '',
      ));
    });
  }
}

extension WalletInfoQueryObject
    on QueryBuilder<WalletInfo, WalletInfo, QFilterCondition> {}

extension WalletInfoQueryLinks
    on QueryBuilder<WalletInfo, WalletInfo, QFilterCondition> {}

extension WalletInfoQuerySortBy
    on QueryBuilder<WalletInfo, WalletInfo, QSortBy> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByAdminKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminKey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByAdminKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminKey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByConfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByConfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByInvoiceKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceKey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByInvoiceKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceKey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByIsEmptyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUrl', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUrl', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUserId', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUserId', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByLnbitsUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUsername', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByLnbitsUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUsername', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByReadKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readKey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByReadKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readKey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByReservedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByReservedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByTotalBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByTotalBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      sortByUnconfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletInfoQuerySortThenBy
    on QueryBuilder<WalletInfo, WalletInfo, QSortThenBy> {
  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByAdminKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminKey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByAdminKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminKey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByConfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByConfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByInvoiceKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceKey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByInvoiceKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceKey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByIsEmptyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUrl', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUrl', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUserId', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUserId', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByLnbitsUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUsername', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByLnbitsUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnbitsUsername', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByReadKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readKey', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByReadKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readKey', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByReservedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByReservedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByTotalBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByTotalBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy>
      thenByUnconfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QAfterSortBy> thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletInfoQueryWhereDistinct
    on QueryBuilder<WalletInfo, WalletInfo, QDistinct> {
  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByAdminKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adminKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedBalance');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct>
      distinctByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByInvoiceKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEmpty');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByLnbitsUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lnbitsUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByLnbitsUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lnbitsUserId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByLnbitsUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lnbitsUsername',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByReadKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reservedBalance');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct>
      distinctByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reservedBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBalance');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct>
      distinctByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unconfirmedBalance');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct>
      distinctByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unconfirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, WalletInfo, QDistinct> distinctByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId', caseSensitive: caseSensitive);
    });
  }
}

extension WalletInfoQueryProperty
    on QueryBuilder<WalletInfo, WalletInfo, QQueryProperty> {
  QueryBuilder<WalletInfo, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> adminKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adminKey');
    });
  }

  QueryBuilder<WalletInfo, int, QQueryOperations> confirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedBalance');
    });
  }

  QueryBuilder<WalletInfo, double, QQueryOperations>
      confirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> invoiceKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceKey');
    });
  }

  QueryBuilder<WalletInfo, bool, QQueryOperations> isEmptyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEmpty');
    });
  }

  QueryBuilder<WalletInfo, int, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> lnbitsUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lnbitsUrl');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> lnbitsUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lnbitsUserId');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> lnbitsUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lnbitsUsername');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubkey');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> readKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readKey');
    });
  }

  QueryBuilder<WalletInfo, int, QQueryOperations> reservedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reservedBalance');
    });
  }

  QueryBuilder<WalletInfo, double, QQueryOperations>
      reservedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reservedBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, int, QQueryOperations> totalBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBalance');
    });
  }

  QueryBuilder<WalletInfo, double, QQueryOperations> totalBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, int, QQueryOperations> unconfirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unconfirmedBalance');
    });
  }

  QueryBuilder<WalletInfo, double, QQueryOperations>
      unconfirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unconfirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletInfo, String, QQueryOperations> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
