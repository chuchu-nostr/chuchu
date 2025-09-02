// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_invoice.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalletInvoiceCollection on Isar {
  IsarCollection<WalletInvoice> get walletInvoices => this.collection();
}

const WalletInvoiceSchema = CollectionSchema(
  name: r'WalletInvoice',
  id: -8213832481351696553,
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
    r'bolt11': PropertySchema(
      id: 2,
      name: r'bolt11',
      type: IsarType.string,
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
    r'expiresAt': PropertySchema(
      id: 5,
      name: r'expiresAt',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 6,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'invoiceId': PropertySchema(
      id: 7,
      name: r'invoiceId',
      type: IsarType.string,
    ),
    r'isCancelled': PropertySchema(
      id: 8,
      name: r'isCancelled',
      type: IsarType.bool,
    ),
    r'isExpired': PropertySchema(
      id: 9,
      name: r'isExpired',
      type: IsarType.bool,
    ),
    r'isExpiringSoon': PropertySchema(
      id: 10,
      name: r'isExpiringSoon',
      type: IsarType.bool,
    ),
    r'isPaid': PropertySchema(
      id: 11,
      name: r'isPaid',
      type: IsarType.bool,
    ),
    r'isPending': PropertySchema(
      id: 12,
      name: r'isPending',
      type: IsarType.bool,
    ),
    r'paidAt': PropertySchema(
      id: 13,
      name: r'paidAt',
      type: IsarType.long,
    ),
    r'paymentHash': PropertySchema(
      id: 14,
      name: r'paymentHash',
      type: IsarType.string,
    ),
    r'preimage': PropertySchema(
      id: 15,
      name: r'preimage',
      type: IsarType.string,
    ),
    r'relatedPubkey': PropertySchema(
      id: 16,
      name: r'relatedPubkey',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 17,
      name: r'status',
      type: IsarType.byte,
      enumMap: _WalletInvoicestatusEnumValueMap,
    ),
    r'timeUntilExpiration': PropertySchema(
      id: 18,
      name: r'timeUntilExpiration',
      type: IsarType.long,
    ),
    r'walletId': PropertySchema(
      id: 19,
      name: r'walletId',
      type: IsarType.string,
    )
  },
  estimateSize: _walletInvoiceEstimateSize,
  serialize: _walletInvoiceSerialize,
  deserialize: _walletInvoiceDeserialize,
  deserializeProp: _walletInvoiceDeserializeProp,
  idName: r'id',
  indexes: {
    r'invoiceId': IndexSchema(
      id: 7861523084118270123,
      name: r'invoiceId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'invoiceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _walletInvoiceGetId,
  getLinks: _walletInvoiceGetLinks,
  attach: _walletInvoiceAttach,
  version: '3.1.0+1',
);

int _walletInvoiceEstimateSize(
  WalletInvoice object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bolt11.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.invoiceId.length * 3;
  bytesCount += 3 + object.paymentHash.length * 3;
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
  bytesCount += 3 + object.walletId.length * 3;
  return bytesCount;
}

void _walletInvoiceSerialize(
  WalletInvoice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeDouble(offsets[1], object.amountBTC);
  writer.writeString(offsets[2], object.bolt11);
  writer.writeLong(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.description);
  writer.writeLong(offsets[5], object.expiresAt);
  writer.writeLong(offsets[6], object.hashCode);
  writer.writeString(offsets[7], object.invoiceId);
  writer.writeBool(offsets[8], object.isCancelled);
  writer.writeBool(offsets[9], object.isExpired);
  writer.writeBool(offsets[10], object.isExpiringSoon);
  writer.writeBool(offsets[11], object.isPaid);
  writer.writeBool(offsets[12], object.isPending);
  writer.writeLong(offsets[13], object.paidAt);
  writer.writeString(offsets[14], object.paymentHash);
  writer.writeString(offsets[15], object.preimage);
  writer.writeString(offsets[16], object.relatedPubkey);
  writer.writeByte(offsets[17], object.status.index);
  writer.writeLong(offsets[18], object.timeUntilExpiration);
  writer.writeString(offsets[19], object.walletId);
}

WalletInvoice _walletInvoiceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalletInvoice(
    amount: reader.readLong(offsets[0]),
    bolt11: reader.readString(offsets[2]),
    createdAt: reader.readLong(offsets[3]),
    description: reader.readStringOrNull(offsets[4]),
    expiresAt: reader.readLong(offsets[5]),
    invoiceId: reader.readString(offsets[7]),
    paidAt: reader.readLongOrNull(offsets[13]),
    paymentHash: reader.readString(offsets[14]),
    preimage: reader.readStringOrNull(offsets[15]),
    relatedPubkey: reader.readStringOrNull(offsets[16]),
    status:
        _WalletInvoicestatusValueEnumMap[reader.readByteOrNull(offsets[17])] ??
            InvoiceStatus.pending,
    walletId: reader.readString(offsets[19]),
  );
  object.id = id;
  return object;
}

P _walletInvoiceDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (_WalletInvoicestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          InvoiceStatus.pending) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WalletInvoicestatusEnumValueMap = {
  'pending': 0,
  'paid': 1,
  'expired': 2,
  'cancelled': 3,
};
const _WalletInvoicestatusValueEnumMap = {
  0: InvoiceStatus.pending,
  1: InvoiceStatus.paid,
  2: InvoiceStatus.expired,
  3: InvoiceStatus.cancelled,
};

Id _walletInvoiceGetId(WalletInvoice object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletInvoiceGetLinks(WalletInvoice object) {
  return [];
}

void _walletInvoiceAttach(
    IsarCollection<dynamic> col, Id id, WalletInvoice object) {
  object.id = id;
}

extension WalletInvoiceByIndex on IsarCollection<WalletInvoice> {
  Future<WalletInvoice?> getByInvoiceId(String invoiceId) {
    return getByIndex(r'invoiceId', [invoiceId]);
  }

  WalletInvoice? getByInvoiceIdSync(String invoiceId) {
    return getByIndexSync(r'invoiceId', [invoiceId]);
  }

  Future<bool> deleteByInvoiceId(String invoiceId) {
    return deleteByIndex(r'invoiceId', [invoiceId]);
  }

  bool deleteByInvoiceIdSync(String invoiceId) {
    return deleteByIndexSync(r'invoiceId', [invoiceId]);
  }

  Future<List<WalletInvoice?>> getAllByInvoiceId(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'invoiceId', values);
  }

  List<WalletInvoice?> getAllByInvoiceIdSync(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'invoiceId', values);
  }

  Future<int> deleteAllByInvoiceId(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'invoiceId', values);
  }

  int deleteAllByInvoiceIdSync(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'invoiceId', values);
  }

  Future<Id> putByInvoiceId(WalletInvoice object) {
    return putByIndex(r'invoiceId', object);
  }

  Id putByInvoiceIdSync(WalletInvoice object, {bool saveLinks = true}) {
    return putByIndexSync(r'invoiceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInvoiceId(List<WalletInvoice> objects) {
    return putAllByIndex(r'invoiceId', objects);
  }

  List<Id> putAllByInvoiceIdSync(List<WalletInvoice> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'invoiceId', objects, saveLinks: saveLinks);
  }
}

extension WalletInvoiceQueryWhereSort
    on QueryBuilder<WalletInvoice, WalletInvoice, QWhere> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletInvoiceQueryWhere
    on QueryBuilder<WalletInvoice, WalletInvoice, QWhereClause> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhereClause> idBetween(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhereClause>
      invoiceIdEqualTo(String invoiceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'invoiceId',
        value: [invoiceId],
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterWhereClause>
      invoiceIdNotEqualTo(String invoiceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [],
              upper: [invoiceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [invoiceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [invoiceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [],
              upper: [invoiceId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WalletInvoiceQueryFilter
    on QueryBuilder<WalletInvoice, WalletInvoice, QFilterCondition> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bolt11',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bolt11',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bolt11',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bolt11',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      createdAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoiceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoiceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoiceId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isCancelledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCancelled',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isExpiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExpired',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isExpiringSoonEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExpiringSoon',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isPaidEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isPendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPending',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paidAt',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paidAt',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paidAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashEqualTo(
    String value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashGreaterThan(
    String value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashLessThan(
    String value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashBetween(
    String lower,
    String upper, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentHash',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentHash',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'preimage',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'preimage',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preimage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preimage',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preimage',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relatedPubkey',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relatedPubkey',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relatedPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relatedPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relatedPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relatedPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusEqualTo(InvoiceStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusGreaterThan(
    InvoiceStatus value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusLessThan(
    InvoiceStatus value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusBetween(
    InvoiceStatus lower,
    InvoiceStatus upper, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeUntilExpiration',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeUntilExpiration',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeUntilExpiration',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeUntilExpiration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'walletId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'walletId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'walletId',
        value: '',
      ));
    });
  }
}

extension WalletInvoiceQueryObject
    on QueryBuilder<WalletInvoice, WalletInvoice, QFilterCondition> {}

extension WalletInvoiceQueryLinks
    on QueryBuilder<WalletInvoice, WalletInvoice, QFilterCondition> {}

extension WalletInvoiceQuerySortBy
    on QueryBuilder<WalletInvoice, WalletInvoice, QSortBy> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByBolt11() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByBolt11Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsExpiringSoonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPaymentHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByPaymentHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPreimage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByPreimageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByRelatedPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByRelatedPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByTimeUntilExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeUntilExpiration', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByTimeUntilExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeUntilExpiration', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletInvoiceQuerySortThenBy
    on QueryBuilder<WalletInvoice, WalletInvoice, QSortThenBy> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountBTC', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByBolt11() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByBolt11Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCancelled', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsExpiringSoonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpiringSoon', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPending', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPaymentHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByPaymentHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentHash', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPreimage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByPreimageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByRelatedPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByRelatedPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relatedPubkey', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByTimeUntilExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeUntilExpiration', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByTimeUntilExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeUntilExpiration', Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension WalletInvoiceQueryWhereDistinct
    on QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> {
  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountBTC');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByBolt11(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bolt11', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByInvoiceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct>
      distinctByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCancelled');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExpired');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct>
      distinctByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExpiringSoon');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaid');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPending');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paidAt');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByPaymentHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByPreimage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preimage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByRelatedPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relatedPubkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct>
      distinctByTimeUntilExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeUntilExpiration');
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> distinctByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId', caseSensitive: caseSensitive);
    });
  }
}

extension WalletInvoiceQueryProperty
    on QueryBuilder<WalletInvoice, WalletInvoice, QQueryProperty> {
  QueryBuilder<WalletInvoice, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalletInvoice, int, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<WalletInvoice, double, QQueryOperations> amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountBTC');
    });
  }

  QueryBuilder<WalletInvoice, String, QQueryOperations> bolt11Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bolt11');
    });
  }

  QueryBuilder<WalletInvoice, int, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WalletInvoice, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<WalletInvoice, int, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<WalletInvoice, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<WalletInvoice, String, QQueryOperations> invoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceId');
    });
  }

  QueryBuilder<WalletInvoice, bool, QQueryOperations> isCancelledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCancelled');
    });
  }

  QueryBuilder<WalletInvoice, bool, QQueryOperations> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExpired');
    });
  }

  QueryBuilder<WalletInvoice, bool, QQueryOperations> isExpiringSoonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExpiringSoon');
    });
  }

  QueryBuilder<WalletInvoice, bool, QQueryOperations> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaid');
    });
  }

  QueryBuilder<WalletInvoice, bool, QQueryOperations> isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPending');
    });
  }

  QueryBuilder<WalletInvoice, int?, QQueryOperations> paidAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paidAt');
    });
  }

  QueryBuilder<WalletInvoice, String, QQueryOperations> paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentHash');
    });
  }

  QueryBuilder<WalletInvoice, String?, QQueryOperations> preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preimage');
    });
  }

  QueryBuilder<WalletInvoice, String?, QQueryOperations>
      relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relatedPubkey');
    });
  }

  QueryBuilder<WalletInvoice, InvoiceStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<WalletInvoice, int, QQueryOperations>
      timeUntilExpirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeUntilExpiration');
    });
  }

  QueryBuilder<WalletInvoice, String, QQueryOperations> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
