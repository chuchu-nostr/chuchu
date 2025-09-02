// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalletTransactionCollection on Isar {
  IsarCollection<WalletTransaction> get walletTransactions => this.collection();
}

const WalletTransactionSchema = CollectionSchema(
  name: r'WalletTransaction',
  id: -3675884309773115998,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.long,
    ),
    r'amountBTC': PropertySchema(
      id: 1,
      name: r'amountBTC',
      type: IsarType.double,
    ),
    r'confirmedAt': PropertySchema(
      id: 2,
      name: r'confirmedAt',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 4,
      name: r'description',
      type: IsarType.string,
    ),
    r'fee': PropertySchema(
      id: 5,
      name: r'fee',
      type: IsarType.long,
    ),
    r'feeBTC': PropertySchema(
      id: 6,
      name: r'feeBTC',
      type: IsarType.double,
    ),
    r'hashCode': PropertySchema(
      id: 7,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'invoice': PropertySchema(
      id: 8,
      name: r'invoice',
      type: IsarType.string,
    ),
    r'isConfirmed': PropertySchema(
      id: 9,
      name: r'isConfirmed',
      type: IsarType.bool,
    ),
    r'isExpired': PropertySchema(
      id: 10,
      name: r'isExpired',
      type: IsarType.bool,
    ),
    r'isFailed': PropertySchema(
      id: 11,
      name: r'isFailed',
      type: IsarType.bool,
    ),
    r'isIncoming': PropertySchema(
      id: 12,
      name: r'isIncoming',
      type: IsarType.bool,
    ),
    r'isOutgoing': PropertySchema(
      id: 13,
      name: r'isOutgoing',
      type: IsarType.bool,
    ),
    r'isPending': PropertySchema(
      id: 14,
      name: r'isPending',
      type: IsarType.bool,
    ),
    r'netAmount': PropertySchema(
      id: 15,
      name: r'netAmount',
      type: IsarType.long,
    ),
    r'netAmountBTC': PropertySchema(
      id: 16,
      name: r'netAmountBTC',
      type: IsarType.double,
    ),
    r'paymentHash': PropertySchema(
      id: 17,
      name: r'paymentHash',
      type: IsarType.string,
    ),
    r'preimage': PropertySchema(
      id: 18,
      name: r'preimage',
      type: IsarType.string,
    ),
    r'relatedPubkey': PropertySchema(
      id: 19,
      name: r'relatedPubkey',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 20,
      name: r'status',
      type: IsarType.byte,
      enumMap: _WalletTransactionstatusEnumValueMap,
    ),
    r'transactionId': PropertySchema(
      id: 21,
      name: r'transactionId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 22,
      name: r'type',
      type: IsarType.byte,
      enumMap: _WalletTransactiontypeEnumValueMap,
    ),
    r'walletId': PropertySchema(
      id: 23,
      name: r'walletId',
      type: IsarType.string,
    )
  },
  estimateSize: _walletTransactionEstimateSize,
  serialize: _walletTransactionSerialize,
  deserialize: _walletTransactionDeserialize,
  deserializeProp: _walletTransactionDeserializeProp,
  idName: r'id',
  indexes: {
    r'transactionId': IndexSchema(
      id: 8561542235958051982,
      name: r'transactionId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'transactionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _walletTransactionGetId,
  getLinks: _walletTransactionGetLinks,
  attach: _walletTransactionAttach,
  version: '3.1.0+1',
);

int _walletTransactionEstimateSize(
  WalletTransaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.invoice;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.paymentHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.preimage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.relatedPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.transactionId.length * 3;
  bytesCount += 3 + object.walletId.length * 3;
  return bytesCount;
}

void _walletTransactionSerialize(
  WalletTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeDouble(offsets[1], object.amountBTC);
  writer.writeLong(offsets[2], object.confirmedAt);
  writer.writeLong(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.description);
  writer.writeLong(offsets[5], object.fee);
  writer.writeDouble(offsets[6], object.feeBTC);
  writer.writeLong(offsets[7], object.hashCode);
  writer.writeString(offsets[8], object.invoice);
  writer.writeBool(offsets[9], object.isConfirmed);
  writer.writeBool(offsets[10], object.isExpired);
  writer.writeBool(offsets[11], object.isFailed);
  writer.writeBool(offsets[12], object.isIncoming);
  writer.writeBool(offsets[13], object.isOutgoing);
  writer.writeBool(offsets[14], object.isPending);
  writer.writeLong(offsets[15], object.netAmount);
  writer.writeDouble(offsets[16], object.netAmountBTC);
  writer.writeString(offsets[17], object.paymentHash);
  writer.writeString(offsets[18], object.preimage);
  writer.writeString(offsets[19], object.relatedPubkey);
  writer.writeByte(offsets[20], object.status.index);
  writer.writeString(offsets[21], object.transactionId);
  writer.writeByte(offsets[22], object.type.index);
  writer.writeString(offsets[23], object.walletId);
}

WalletTransaction _walletTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalletTransaction(
    amount: reader.readLong(offsets[0]),
    confirmedAt: reader.readLongOrNull(offsets[2]),
    createdAt: reader.readLong(offsets[3]),
    description: reader.readStringOrNull(offsets[4]),
    fee: reader.readLongOrNull(offsets[5]) ?? 0,
    invoice: reader.readStringOrNull(offsets[8]),
    paymentHash: reader.readStringOrNull(offsets[17]),
    preimage: reader.readStringOrNull(offsets[18]),
    relatedPubkey: reader.readStringOrNull(offsets[19]),
    status: _WalletTransactionstatusValueEnumMap[
            reader.readByteOrNull(offsets[20])] ??
        TransactionStatus.pending,
    transactionId: reader.readString(offsets[21]),
    type: _WalletTransactiontypeValueEnumMap[
            reader.readByteOrNull(offsets[22])] ??
        TransactionType.incoming,
    walletId: reader.readString(offsets[23]),
  );
  object.id = id;
  return object;
}

P _walletTransactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (_WalletTransactionstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransactionStatus.pending) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (_WalletTransactiontypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TransactionType.incoming) as P;
    case 23:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WalletTransactionstatusEnumValueMap = {
  'pending': 0,
  'confirmed': 1,
  'failed': 2,
  'expired': 3,
};
const _WalletTransactionstatusValueEnumMap = {
  0: TransactionStatus.pending,
  1: TransactionStatus.confirmed,
  2: TransactionStatus.failed,
  3: TransactionStatus.expired,
};
const _WalletTransactiontypeEnumValueMap = {
  'incoming': 0,
  'outgoing': 1,
};
const _WalletTransactiontypeValueEnumMap = {
  0: TransactionType.incoming,
  1: TransactionType.outgoing,
};

Id _walletTransactionGetId(WalletTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletTransactionGetLinks(
    WalletTransaction object) {
  return [];
}

void _walletTransactionAttach(
    IsarCollection<dynamic> col, Id id, WalletTransaction object) {
  object.id = id;
}

extension WalletTransactionByIndex on IsarCollection<WalletTransaction> {
  Future<WalletTransaction?> getByTransactionId(String transactionId) {
    return getByIndex(r'transactionId', [transactionId]);
  }

  WalletTransaction? getByTransactionIdSync(String transactionId) {
    return getByIndexSync(r'transactionId', [transactionId]);
  }

  Future<bool> deleteByTransactionId(String transactionId) {
    return deleteByIndex(r'transactionId', [transactionId]);
  }

  bool deleteByTransactionIdSync(String transactionId) {
    return deleteByIndexSync(r'transactionId', [transactionId]);
  }

  Future<List<WalletTransaction?>> getAllByTransactionId(
      List<String> transactionIdValues) {
    final values = transactionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'transactionId', values);
  }

  List<WalletTransaction?> getAllByTransactionIdSync(
      List<String> transactionIdValues) {
    final values = transactionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'transactionId', values);
  }

  Future<int> deleteAllByTransactionId(List<String> transactionIdValues) {
    final values = transactionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'transactionId', values);
  }

  int deleteAllByTransactionIdSync(List<String> transactionIdValues) {
    final values = transactionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'transactionId', values);
  }

  Future<Id> putByTransactionId(WalletTransaction object) {
    return putByIndex(r'transactionId', object);
  }

  Id putByTransactionIdSync(WalletTransaction object, {bool saveLinks = true}) {
    return putByIndexSync(r'transactionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTransactionId(List<WalletTransaction> objects) {
    return putAllByIndex(r'transactionId', objects);
  }

  List<Id> putAllByTransactionIdSync(List<WalletTransaction> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'transactionId', objects, saveLinks: saveLinks);
  }
}

extension WalletTransactionQueryWhereSort
    on QueryBuilder<WalletTransaction, WalletTransaction, QWhere> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletTransactionQueryWhere
    on QueryBuilder<WalletTransaction, WalletTransaction, QWhereClause> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhereClause>
      transactionIdEqualTo(String transactionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'transactionId',
        value: [transactionId],
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterWhereClause>
      transactionIdNotEqualTo(String transactionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [],
              upper: [transactionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [transactionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [transactionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [],
              upper: [transactionId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WalletTransactionQueryFilter
    on QueryBuilder<WalletTransaction, WalletTransaction, QFilterCondition> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountBTC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confirmedAt',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confirmedAt',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confirmedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fee',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fee',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fee',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feeBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feeBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feeBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feeBTC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'invoice',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'invoice',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoice',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoice',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoice',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isConfirmed',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isExpiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExpired',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isFailedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFailed',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isIncomingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isIncoming',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isOutgoingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOutgoing',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isPendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPending',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'netAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'netAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'netAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'netAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'netAmountBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'netAmountBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'netAmountBTC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'netAmountBTC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paymentHash',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paymentHash',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentHash',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentHash',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'preimage',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'preimage',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preimage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preimage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preimage',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preimage',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relatedPubkey',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relatedPubkey',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relatedPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relatedPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relatedPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relatedPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relatedPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relatedPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relatedPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relatedPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relatedPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relatedPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusEqualTo(TransactionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusGreaterThan(
    TransactionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusLessThan(
    TransactionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusBetween(
    TransactionStatus lower,
    TransactionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transactionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transactionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeEqualTo(TransactionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeGreaterThan(
    TransactionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeLessThan(
    TransactionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeBetween(
    TransactionType lower,
    TransactionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'walletId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'walletId',
        value: '',
      ));
    });
  }
}

extension WalletTransactionQueryObject
    on QueryBuilder<WalletTransaction, WalletTransaction, QFilterCondition> {}

extension WalletTransactionQueryLinks
    on QueryBuilder<WalletTransaction, WalletTransaction, QFilterCondition> {}

extension WalletTransactionQuerySortBy
    on QueryBuilder<WalletTransaction, WalletTransaction, QSortBy> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy> sortByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByFeeBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByFeeBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByInvoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoice', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByInvoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoice', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsIncoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncoming', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsIncomingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncoming', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsOutgoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutgoing', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsOutgoingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutgoing', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmount', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmount', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmountBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmountBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPaymentHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPaymentHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPreimage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPreimageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByRelatedPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByRelatedPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletTransactionQuerySortThenBy
    on QueryBuilder<WalletTransaction, WalletTransaction, QSortThenBy> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy> thenByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByFeeBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByFeeBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByInvoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoice', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByInvoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoice', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConfirmed', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsIncoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncoming', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsIncomingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isIncoming', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsOutgoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutgoing', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsOutgoingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOutgoing', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmount', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmount', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmountBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netAmountBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPaymentHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPaymentHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPreimage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPreimageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByRelatedPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByRelatedPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletTransactionQueryWhereDistinct
    on QueryBuilder<WalletTransaction, WalletTransaction, QDistinct> {
  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountBTC');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedAt');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fee');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByFeeBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feeBTC');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByInvoice({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoice', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isConfirmed');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExpired');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFailed');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByIsIncoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isIncoming');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByIsOutgoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOutgoing');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPending');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByNetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'netAmount');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByNetAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'netAmountBTC');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByPaymentHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByPreimage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preimage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByRelatedPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relatedPubkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transactionId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QDistinct>
      distinctByWalletId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId', caseSensitive: caseSensitive);
    });
  }
}

extension WalletTransactionQueryProperty
    on QueryBuilder<WalletTransaction, WalletTransaction, QQueryProperty> {
  QueryBuilder<WalletTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalletTransaction, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<WalletTransaction, double, QQueryOperations>
      amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountBTC');
    });
  }

  QueryBuilder<WalletTransaction, int?, QQueryOperations>
      confirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedAt');
    });
  }

  QueryBuilder<WalletTransaction, int, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WalletTransaction, String?, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<WalletTransaction, int, QQueryOperations> feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fee');
    });
  }

  QueryBuilder<WalletTransaction, double, QQueryOperations> feeBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feeBTC');
    });
  }

  QueryBuilder<WalletTransaction, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<WalletTransaction, String?, QQueryOperations> invoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoice');
    });
  }

  QueryBuilder<WalletTransaction, bool, QQueryOperations>
      isConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isConfirmed');
    });
  }

  QueryBuilder<WalletTransaction, bool, QQueryOperations> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExpired');
    });
  }

  QueryBuilder<WalletTransaction, bool, QQueryOperations> isFailedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFailed');
    });
  }

  QueryBuilder<WalletTransaction, bool, QQueryOperations> isIncomingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isIncoming');
    });
  }

  QueryBuilder<WalletTransaction, bool, QQueryOperations> isOutgoingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOutgoing');
    });
  }

  QueryBuilder<WalletTransaction, bool, QQueryOperations> isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPending');
    });
  }

  QueryBuilder<WalletTransaction, int, QQueryOperations> netAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'netAmount');
    });
  }

  QueryBuilder<WalletTransaction, double, QQueryOperations>
      netAmountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'netAmountBTC');
    });
  }

  QueryBuilder<WalletTransaction, String?, QQueryOperations>
      paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentHash');
    });
  }

  QueryBuilder<WalletTransaction, String?, QQueryOperations>
      preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preimage');
    });
  }

  QueryBuilder<WalletTransaction, String?, QQueryOperations>
      relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relatedPubkey');
    });
  }

  QueryBuilder<WalletTransaction, TransactionStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<WalletTransaction, String, QQueryOperations>
      transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactionId');
    });
  }

  QueryBuilder<WalletTransaction, TransactionType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<WalletTransaction, String, QQueryOperations> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
