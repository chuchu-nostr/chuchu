// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_balance.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalletBalanceCollection on Isar {
  IsarCollection<WalletBalance> get walletBalances => this.collection();
}

const WalletBalanceSchema = CollectionSchema(
  name: r'WalletBalance',
  id: -6444879127821687157,
  properties: {
    r'confirmedBalance': PropertySchema(
      id: 0,
      name: r'confirmedBalance',
      type: IsarType.long,
    ),
    r'confirmedBalanceBTC': PropertySchema(
      id: 1,
      name: r'confirmedBalanceBTC',
      type: IsarType.double,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'isEmpty': PropertySchema(
      id: 3,
      name: r'isEmpty',
      type: IsarType.bool,
    ),
    r'lastUpdated': PropertySchema(
      id: 4,
      name: r'lastUpdated',
      type: IsarType.long,
    ),
    r'reservedBalance': PropertySchema(
      id: 5,
      name: r'reservedBalance',
      type: IsarType.long,
    ),
    r'reservedBalanceBTC': PropertySchema(
      id: 6,
      name: r'reservedBalanceBTC',
      type: IsarType.double,
    ),
    r'totalBalance': PropertySchema(
      id: 7,
      name: r'totalBalance',
      type: IsarType.long,
    ),
    r'totalBalanceBTC': PropertySchema(
      id: 8,
      name: r'totalBalanceBTC',
      type: IsarType.double,
    ),
    r'unconfirmedBalance': PropertySchema(
      id: 9,
      name: r'unconfirmedBalance',
      type: IsarType.long,
    ),
    r'unconfirmedBalanceBTC': PropertySchema(
      id: 10,
      name: r'unconfirmedBalanceBTC',
      type: IsarType.double,
    ),
    r'walletId': PropertySchema(
      id: 11,
      name: r'walletId',
      type: IsarType.string,
    )
  },
  estimateSize: _walletBalanceEstimateSize,
  serialize: _walletBalanceSerialize,
  deserialize: _walletBalanceDeserialize,
  deserializeProp: _walletBalanceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _walletBalanceGetId,
  getLinks: _walletBalanceGetLinks,
  attach: _walletBalanceAttach,
  version: '3.1.0+1',
);

int _walletBalanceEstimateSize(
  WalletBalance object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.walletId.length * 3;
  return bytesCount;
}

void _walletBalanceSerialize(
  WalletBalance object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.confirmedBalance);
  writer.writeDouble(offsets[1], object.confirmedBalanceBTC);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeBool(offsets[3], object.isEmpty);
  writer.writeLong(offsets[4], object.lastUpdated);
  writer.writeLong(offsets[5], object.reservedBalance);
  writer.writeDouble(offsets[6], object.reservedBalanceBTC);
  writer.writeLong(offsets[7], object.totalBalance);
  writer.writeDouble(offsets[8], object.totalBalanceBTC);
  writer.writeLong(offsets[9], object.unconfirmedBalance);
  writer.writeDouble(offsets[10], object.unconfirmedBalanceBTC);
  writer.writeString(offsets[11], object.walletId);
}

WalletBalance _walletBalanceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalletBalance(
    confirmedBalance: reader.readLongOrNull(offsets[0]) ?? 0,
    lastUpdated: reader.readLongOrNull(offsets[4]) ?? 0,
    reservedBalance: reader.readLongOrNull(offsets[5]) ?? 0,
    totalBalance: reader.readLongOrNull(offsets[7]) ?? 0,
    unconfirmedBalance: reader.readLongOrNull(offsets[9]) ?? 0,
    walletId: reader.readStringOrNull(offsets[11]) ?? '',
  );
  object.id = id;
  return object;
}

P _walletBalanceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _walletBalanceGetId(WalletBalance object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletBalanceGetLinks(WalletBalance object) {
  return [];
}

void _walletBalanceAttach(
    IsarCollection<dynamic> col, Id id, WalletBalance object) {
  object.id = id;
}

extension WalletBalanceQueryWhereSort
    on QueryBuilder<WalletBalance, WalletBalance, QWhere> {
  QueryBuilder<WalletBalance, WalletBalance, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletBalanceQueryWhere
    on QueryBuilder<WalletBalance, WalletBalance, QWhereClause> {
  QueryBuilder<WalletBalance, WalletBalance, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterWhereClause> idBetween(
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
}

extension WalletBalanceQueryFilter
    on QueryBuilder<WalletBalance, WalletBalance, QFilterCondition> {
  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      confirmedBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      hashCodeLessThan(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      hashCodeBetween(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      isEmptyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEmpty',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      lastUpdatedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      reservedBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reservedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      totalBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      unconfirmedBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unconfirmedBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdEqualTo(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdLessThan(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdBetween(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdEndsWith(
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

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'walletId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterFilterCondition>
      walletIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'walletId',
        value: '',
      ));
    });
  }
}

extension WalletBalanceQueryObject
    on QueryBuilder<WalletBalance, WalletBalance, QFilterCondition> {}

extension WalletBalanceQueryLinks
    on QueryBuilder<WalletBalance, WalletBalance, QFilterCondition> {}

extension WalletBalanceQuerySortBy
    on QueryBuilder<WalletBalance, WalletBalance, QSortBy> {
  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByConfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByConfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> sortByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> sortByIsEmptyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByReservedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByReservedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByTotalBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByTotalBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByUnconfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByUnconfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletBalanceQuerySortThenBy
    on QueryBuilder<WalletBalance, WalletBalance, QSortThenBy> {
  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByConfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByConfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> thenByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> thenByIsEmptyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmpty', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByReservedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByReservedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reservedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByTotalBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByTotalBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByUnconfirmedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalance', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByUnconfirmedBalanceBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unconfirmedBalanceBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy> thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QAfterSortBy>
      thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletBalanceQueryWhereDistinct
    on QueryBuilder<WalletBalance, WalletBalance, QDistinct> {
  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByConfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedBalance');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByConfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct> distinctByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEmpty');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByReservedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reservedBalance');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByReservedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reservedBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByTotalBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBalance');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByTotalBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByUnconfirmedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unconfirmedBalance');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct>
      distinctByUnconfirmedBalanceBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unconfirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, WalletBalance, QDistinct> distinctByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId', caseSensitive: caseSensitive);
    });
  }
}

extension WalletBalanceQueryProperty
    on QueryBuilder<WalletBalance, WalletBalance, QQueryProperty> {
  QueryBuilder<WalletBalance, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalletBalance, int, QQueryOperations>
      confirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedBalance');
    });
  }

  QueryBuilder<WalletBalance, double, QQueryOperations>
      confirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<WalletBalance, bool, QQueryOperations> isEmptyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEmpty');
    });
  }

  QueryBuilder<WalletBalance, int, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<WalletBalance, int, QQueryOperations> reservedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reservedBalance');
    });
  }

  QueryBuilder<WalletBalance, double, QQueryOperations>
      reservedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reservedBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, int, QQueryOperations> totalBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBalance');
    });
  }

  QueryBuilder<WalletBalance, double, QQueryOperations>
      totalBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, int, QQueryOperations>
      unconfirmedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unconfirmedBalance');
    });
  }

  QueryBuilder<WalletBalance, double, QQueryOperations>
      unconfirmedBalanceBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unconfirmedBalanceBTC');
    });
  }

  QueryBuilder<WalletBalance, String, QQueryOperations> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
