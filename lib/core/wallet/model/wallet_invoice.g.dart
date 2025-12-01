// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_invoice.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetWalletInvoiceCollection on Isar {
  IsarCollection<int, WalletInvoice> get walletInvoices => this.collection();
}

const WalletInvoiceSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'WalletInvoice',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'invoiceId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'bolt11',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'paymentHash',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'amount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'description',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'status',
        type: IsarType.byte,
        enumMap: {"pending": 0, "paid": 1, "expired": 2, "cancelled": 3},
      ),
      IsarPropertySchema(
        name: 'createdAt',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'expiresAt',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'paidAt',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'walletId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'relatedPubkey',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'preimage',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'amountBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'isPaid',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isPending',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isExpired',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isCancelled',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'timeUntilExpiration',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'isExpiringSoon',
        type: IsarType.bool,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'invoiceId',
        properties: [
          "invoiceId",
        ],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, WalletInvoice>(
    serialize: serializeWalletInvoice,
    deserialize: deserializeWalletInvoice,
    deserializeProperty: deserializeWalletInvoiceProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeWalletInvoice(IsarWriter writer, WalletInvoice object) {
  IsarCore.writeString(writer, 1, object.invoiceId);
  IsarCore.writeString(writer, 2, object.bolt11);
  IsarCore.writeString(writer, 3, object.paymentHash);
  IsarCore.writeLong(writer, 4, object.amount);
  {
    final value = object.description;
    if (value == null) {
      IsarCore.writeNull(writer, 5);
    } else {
      IsarCore.writeString(writer, 5, value);
    }
  }
  IsarCore.writeByte(writer, 6, object.status.index);
  IsarCore.writeLong(writer, 7, object.createdAt);
  IsarCore.writeLong(writer, 8, object.expiresAt);
  IsarCore.writeLong(writer, 9, object.paidAt ?? -9223372036854775808);
  IsarCore.writeString(writer, 10, object.walletId);
  {
    final value = object.relatedPubkey;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  {
    final value = object.preimage;
    if (value == null) {
      IsarCore.writeNull(writer, 12);
    } else {
      IsarCore.writeString(writer, 12, value);
    }
  }
  IsarCore.writeDouble(writer, 13, object.amountBTC);
  IsarCore.writeBool(writer, 14, object.isPaid);
  IsarCore.writeBool(writer, 15, object.isPending);
  IsarCore.writeBool(writer, 16, object.isExpired);
  IsarCore.writeBool(writer, 17, object.isCancelled);
  IsarCore.writeLong(writer, 18, object.timeUntilExpiration);
  IsarCore.writeBool(writer, 19, object.isExpiringSoon);
  return object.id;
}

@isarProtected
WalletInvoice deserializeWalletInvoice(IsarReader reader) {
  final String _invoiceId;
  _invoiceId = IsarCore.readString(reader, 1) ?? '';
  final String _bolt11;
  _bolt11 = IsarCore.readString(reader, 2) ?? '';
  final String _paymentHash;
  _paymentHash = IsarCore.readString(reader, 3) ?? '';
  final int _amount;
  _amount = IsarCore.readLong(reader, 4);
  final String? _description;
  _description = IsarCore.readString(reader, 5);
  final InvoiceStatus _status;
  {
    if (IsarCore.readNull(reader, 6)) {
      _status = InvoiceStatus.pending;
    } else {
      _status = _walletInvoiceStatus[IsarCore.readByte(reader, 6)] ??
          InvoiceStatus.pending;
    }
  }
  final int _createdAt;
  _createdAt = IsarCore.readLong(reader, 7);
  final int _expiresAt;
  _expiresAt = IsarCore.readLong(reader, 8);
  final int? _paidAt;
  {
    final value = IsarCore.readLong(reader, 9);
    if (value == -9223372036854775808) {
      _paidAt = null;
    } else {
      _paidAt = value;
    }
  }
  final String _walletId;
  _walletId = IsarCore.readString(reader, 10) ?? '';
  final String? _relatedPubkey;
  _relatedPubkey = IsarCore.readString(reader, 11);
  final String? _preimage;
  _preimage = IsarCore.readString(reader, 12);
  final object = WalletInvoice(
    invoiceId: _invoiceId,
    bolt11: _bolt11,
    paymentHash: _paymentHash,
    amount: _amount,
    description: _description,
    status: _status,
    createdAt: _createdAt,
    expiresAt: _expiresAt,
    paidAt: _paidAt,
    walletId: _walletId,
    relatedPubkey: _relatedPubkey,
    preimage: _preimage,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeWalletInvoiceProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readLong(reader, 4);
    case 5:
      return IsarCore.readString(reader, 5);
    case 6:
      {
        if (IsarCore.readNull(reader, 6)) {
          return InvoiceStatus.pending;
        } else {
          return _walletInvoiceStatus[IsarCore.readByte(reader, 6)] ??
              InvoiceStatus.pending;
        }
      }
    case 7:
      return IsarCore.readLong(reader, 7);
    case 8:
      return IsarCore.readLong(reader, 8);
    case 9:
      {
        final value = IsarCore.readLong(reader, 9);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 10:
      return IsarCore.readString(reader, 10) ?? '';
    case 11:
      return IsarCore.readString(reader, 11);
    case 12:
      return IsarCore.readString(reader, 12);
    case 13:
      return IsarCore.readDouble(reader, 13);
    case 14:
      return IsarCore.readBool(reader, 14);
    case 15:
      return IsarCore.readBool(reader, 15);
    case 16:
      return IsarCore.readBool(reader, 16);
    case 17:
      return IsarCore.readBool(reader, 17);
    case 18:
      return IsarCore.readLong(reader, 18);
    case 19:
      return IsarCore.readBool(reader, 19);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _WalletInvoiceUpdate {
  bool call({
    required int id,
    String? invoiceId,
    String? bolt11,
    String? paymentHash,
    int? amount,
    String? description,
    InvoiceStatus? status,
    int? createdAt,
    int? expiresAt,
    int? paidAt,
    String? walletId,
    String? relatedPubkey,
    String? preimage,
    double? amountBTC,
    bool? isPaid,
    bool? isPending,
    bool? isExpired,
    bool? isCancelled,
    int? timeUntilExpiration,
    bool? isExpiringSoon,
  });
}

class _WalletInvoiceUpdateImpl implements _WalletInvoiceUpdate {
  const _WalletInvoiceUpdateImpl(this.collection);

  final IsarCollection<int, WalletInvoice> collection;

  @override
  bool call({
    required int id,
    Object? invoiceId = ignore,
    Object? bolt11 = ignore,
    Object? paymentHash = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? status = ignore,
    Object? createdAt = ignore,
    Object? expiresAt = ignore,
    Object? paidAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? preimage = ignore,
    Object? amountBTC = ignore,
    Object? isPaid = ignore,
    Object? isPending = ignore,
    Object? isExpired = ignore,
    Object? isCancelled = ignore,
    Object? timeUntilExpiration = ignore,
    Object? isExpiringSoon = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (invoiceId != ignore) 1: invoiceId as String?,
          if (bolt11 != ignore) 2: bolt11 as String?,
          if (paymentHash != ignore) 3: paymentHash as String?,
          if (amount != ignore) 4: amount as int?,
          if (description != ignore) 5: description as String?,
          if (status != ignore) 6: status as InvoiceStatus?,
          if (createdAt != ignore) 7: createdAt as int?,
          if (expiresAt != ignore) 8: expiresAt as int?,
          if (paidAt != ignore) 9: paidAt as int?,
          if (walletId != ignore) 10: walletId as String?,
          if (relatedPubkey != ignore) 11: relatedPubkey as String?,
          if (preimage != ignore) 12: preimage as String?,
          if (amountBTC != ignore) 13: amountBTC as double?,
          if (isPaid != ignore) 14: isPaid as bool?,
          if (isPending != ignore) 15: isPending as bool?,
          if (isExpired != ignore) 16: isExpired as bool?,
          if (isCancelled != ignore) 17: isCancelled as bool?,
          if (timeUntilExpiration != ignore) 18: timeUntilExpiration as int?,
          if (isExpiringSoon != ignore) 19: isExpiringSoon as bool?,
        }) >
        0;
  }
}

sealed class _WalletInvoiceUpdateAll {
  int call({
    required List<int> id,
    String? invoiceId,
    String? bolt11,
    String? paymentHash,
    int? amount,
    String? description,
    InvoiceStatus? status,
    int? createdAt,
    int? expiresAt,
    int? paidAt,
    String? walletId,
    String? relatedPubkey,
    String? preimage,
    double? amountBTC,
    bool? isPaid,
    bool? isPending,
    bool? isExpired,
    bool? isCancelled,
    int? timeUntilExpiration,
    bool? isExpiringSoon,
  });
}

class _WalletInvoiceUpdateAllImpl implements _WalletInvoiceUpdateAll {
  const _WalletInvoiceUpdateAllImpl(this.collection);

  final IsarCollection<int, WalletInvoice> collection;

  @override
  int call({
    required List<int> id,
    Object? invoiceId = ignore,
    Object? bolt11 = ignore,
    Object? paymentHash = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? status = ignore,
    Object? createdAt = ignore,
    Object? expiresAt = ignore,
    Object? paidAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? preimage = ignore,
    Object? amountBTC = ignore,
    Object? isPaid = ignore,
    Object? isPending = ignore,
    Object? isExpired = ignore,
    Object? isCancelled = ignore,
    Object? timeUntilExpiration = ignore,
    Object? isExpiringSoon = ignore,
  }) {
    return collection.updateProperties(id, {
      if (invoiceId != ignore) 1: invoiceId as String?,
      if (bolt11 != ignore) 2: bolt11 as String?,
      if (paymentHash != ignore) 3: paymentHash as String?,
      if (amount != ignore) 4: amount as int?,
      if (description != ignore) 5: description as String?,
      if (status != ignore) 6: status as InvoiceStatus?,
      if (createdAt != ignore) 7: createdAt as int?,
      if (expiresAt != ignore) 8: expiresAt as int?,
      if (paidAt != ignore) 9: paidAt as int?,
      if (walletId != ignore) 10: walletId as String?,
      if (relatedPubkey != ignore) 11: relatedPubkey as String?,
      if (preimage != ignore) 12: preimage as String?,
      if (amountBTC != ignore) 13: amountBTC as double?,
      if (isPaid != ignore) 14: isPaid as bool?,
      if (isPending != ignore) 15: isPending as bool?,
      if (isExpired != ignore) 16: isExpired as bool?,
      if (isCancelled != ignore) 17: isCancelled as bool?,
      if (timeUntilExpiration != ignore) 18: timeUntilExpiration as int?,
      if (isExpiringSoon != ignore) 19: isExpiringSoon as bool?,
    });
  }
}

extension WalletInvoiceUpdate on IsarCollection<int, WalletInvoice> {
  _WalletInvoiceUpdate get update => _WalletInvoiceUpdateImpl(this);

  _WalletInvoiceUpdateAll get updateAll => _WalletInvoiceUpdateAllImpl(this);
}

sealed class _WalletInvoiceQueryUpdate {
  int call({
    String? invoiceId,
    String? bolt11,
    String? paymentHash,
    int? amount,
    String? description,
    InvoiceStatus? status,
    int? createdAt,
    int? expiresAt,
    int? paidAt,
    String? walletId,
    String? relatedPubkey,
    String? preimage,
    double? amountBTC,
    bool? isPaid,
    bool? isPending,
    bool? isExpired,
    bool? isCancelled,
    int? timeUntilExpiration,
    bool? isExpiringSoon,
  });
}

class _WalletInvoiceQueryUpdateImpl implements _WalletInvoiceQueryUpdate {
  const _WalletInvoiceQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<WalletInvoice> query;
  final int? limit;

  @override
  int call({
    Object? invoiceId = ignore,
    Object? bolt11 = ignore,
    Object? paymentHash = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? status = ignore,
    Object? createdAt = ignore,
    Object? expiresAt = ignore,
    Object? paidAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? preimage = ignore,
    Object? amountBTC = ignore,
    Object? isPaid = ignore,
    Object? isPending = ignore,
    Object? isExpired = ignore,
    Object? isCancelled = ignore,
    Object? timeUntilExpiration = ignore,
    Object? isExpiringSoon = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (invoiceId != ignore) 1: invoiceId as String?,
      if (bolt11 != ignore) 2: bolt11 as String?,
      if (paymentHash != ignore) 3: paymentHash as String?,
      if (amount != ignore) 4: amount as int?,
      if (description != ignore) 5: description as String?,
      if (status != ignore) 6: status as InvoiceStatus?,
      if (createdAt != ignore) 7: createdAt as int?,
      if (expiresAt != ignore) 8: expiresAt as int?,
      if (paidAt != ignore) 9: paidAt as int?,
      if (walletId != ignore) 10: walletId as String?,
      if (relatedPubkey != ignore) 11: relatedPubkey as String?,
      if (preimage != ignore) 12: preimage as String?,
      if (amountBTC != ignore) 13: amountBTC as double?,
      if (isPaid != ignore) 14: isPaid as bool?,
      if (isPending != ignore) 15: isPending as bool?,
      if (isExpired != ignore) 16: isExpired as bool?,
      if (isCancelled != ignore) 17: isCancelled as bool?,
      if (timeUntilExpiration != ignore) 18: timeUntilExpiration as int?,
      if (isExpiringSoon != ignore) 19: isExpiringSoon as bool?,
    });
  }
}

extension WalletInvoiceQueryUpdate on IsarQuery<WalletInvoice> {
  _WalletInvoiceQueryUpdate get updateFirst =>
      _WalletInvoiceQueryUpdateImpl(this, limit: 1);

  _WalletInvoiceQueryUpdate get updateAll =>
      _WalletInvoiceQueryUpdateImpl(this);
}

class _WalletInvoiceQueryBuilderUpdateImpl
    implements _WalletInvoiceQueryUpdate {
  const _WalletInvoiceQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<WalletInvoice, WalletInvoice, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? invoiceId = ignore,
    Object? bolt11 = ignore,
    Object? paymentHash = ignore,
    Object? amount = ignore,
    Object? description = ignore,
    Object? status = ignore,
    Object? createdAt = ignore,
    Object? expiresAt = ignore,
    Object? paidAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? preimage = ignore,
    Object? amountBTC = ignore,
    Object? isPaid = ignore,
    Object? isPending = ignore,
    Object? isExpired = ignore,
    Object? isCancelled = ignore,
    Object? timeUntilExpiration = ignore,
    Object? isExpiringSoon = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (invoiceId != ignore) 1: invoiceId as String?,
        if (bolt11 != ignore) 2: bolt11 as String?,
        if (paymentHash != ignore) 3: paymentHash as String?,
        if (amount != ignore) 4: amount as int?,
        if (description != ignore) 5: description as String?,
        if (status != ignore) 6: status as InvoiceStatus?,
        if (createdAt != ignore) 7: createdAt as int?,
        if (expiresAt != ignore) 8: expiresAt as int?,
        if (paidAt != ignore) 9: paidAt as int?,
        if (walletId != ignore) 10: walletId as String?,
        if (relatedPubkey != ignore) 11: relatedPubkey as String?,
        if (preimage != ignore) 12: preimage as String?,
        if (amountBTC != ignore) 13: amountBTC as double?,
        if (isPaid != ignore) 14: isPaid as bool?,
        if (isPending != ignore) 15: isPending as bool?,
        if (isExpired != ignore) 16: isExpired as bool?,
        if (isCancelled != ignore) 17: isCancelled as bool?,
        if (timeUntilExpiration != ignore) 18: timeUntilExpiration as int?,
        if (isExpiringSoon != ignore) 19: isExpiringSoon as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension WalletInvoiceQueryBuilderUpdate
    on QueryBuilder<WalletInvoice, WalletInvoice, QOperations> {
  _WalletInvoiceQueryUpdate get updateFirst =>
      _WalletInvoiceQueryBuilderUpdateImpl(this, limit: 1);

  _WalletInvoiceQueryUpdate get updateAll =>
      _WalletInvoiceQueryBuilderUpdateImpl(this);
}

const _walletInvoiceStatus = {
  0: InvoiceStatus.pending,
  1: InvoiceStatus.paid,
  2: InvoiceStatus.expired,
  3: InvoiceStatus.cancelled,
};

extension WalletInvoiceQueryFilter
    on QueryBuilder<WalletInvoice, WalletInvoice, QFilterCondition> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdGreaterThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdGreaterThanOrEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdLessThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdLessThanOrEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdBetween(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdStartsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdEndsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      invoiceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11GreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11GreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11LessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11LessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11Between(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      bolt11IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paymentHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountGreaterThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountGreaterThanOrEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountLessThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountLessThanOrEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountBetween(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusEqualTo(
    InvoiceStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusGreaterThan(
    InvoiceStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusGreaterThanOrEqualTo(
    InvoiceStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusLessThan(
    InvoiceStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusLessThanOrEqualTo(
    InvoiceStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      statusBetween(
    InvoiceStatus lower,
    InvoiceStatus upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower.index,
          upper: upper.index,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      createdAtEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      createdAtGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      createdAtGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      createdAtLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      createdAtLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      createdAtBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      expiresAtBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      paidAtBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdGreaterThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdGreaterThanOrEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdLessThan(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdLessThanOrEqualTo(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdBetween(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdStartsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdEndsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      walletIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyEqualTo(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyGreaterThan(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyLessThan(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyStartsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyEndsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      relatedPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageEqualTo(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageGreaterThan(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageLessThan(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageStartsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageEndsWith(
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      preimageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountBTCEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 13,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountBTCGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 13,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountBTCGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 13,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountBTCLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 13,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountBTCLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 13,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      amountBTCBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 13,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isPaidEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 14,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isPendingEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isExpiredEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 16,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isCancelledEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 17,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationEqualTo(
    int value,
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

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      timeUntilExpirationBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 18,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterFilterCondition>
      isExpiringSoonEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }
}

extension WalletInvoiceQueryObject
    on QueryBuilder<WalletInvoice, WalletInvoice, QFilterCondition> {}

extension WalletInvoiceQuerySortBy
    on QueryBuilder<WalletInvoice, WalletInvoice, QSortBy> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByInvoiceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByInvoiceIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByBolt11(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByBolt11Desc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPaymentHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByPaymentHashDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByWalletIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByRelatedPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByRelatedPubkeyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPreimage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByPreimageDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> sortByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByTimeUntilExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByTimeUntilExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      sortByIsExpiringSoonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }
}

extension WalletInvoiceQuerySortThenBy
    on QueryBuilder<WalletInvoice, WalletInvoice, QSortThenBy> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByInvoiceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByInvoiceIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByBolt11(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByBolt11Desc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPaymentHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByPaymentHashDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByWalletIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByRelatedPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByRelatedPubkeyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPreimage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByPreimageDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy> thenByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsCancelledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByTimeUntilExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByTimeUntilExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterSortBy>
      thenByIsExpiringSoonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }
}

extension WalletInvoiceQueryWhereDistinct
    on QueryBuilder<WalletInvoice, WalletInvoice, QDistinct> {
  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByInvoiceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct> distinctByBolt11(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByPaymentHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct> distinctByWalletId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByRelatedPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct> distinctByPreimage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByIsCancelled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByTimeUntilExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }

  QueryBuilder<WalletInvoice, WalletInvoice, QAfterDistinct>
      distinctByIsExpiringSoon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19);
    });
  }
}

extension WalletInvoiceQueryProperty1
    on QueryBuilder<WalletInvoice, WalletInvoice, QProperty> {
  QueryBuilder<WalletInvoice, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletInvoice, String, QAfterProperty> invoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletInvoice, String, QAfterProperty> bolt11Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletInvoice, String, QAfterProperty> paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletInvoice, int, QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletInvoice, String?, QAfterProperty> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletInvoice, InvoiceStatus, QAfterProperty> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletInvoice, int, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletInvoice, int, QAfterProperty> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletInvoice, int?, QAfterProperty> paidAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletInvoice, String, QAfterProperty> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletInvoice, String?, QAfterProperty> relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletInvoice, String?, QAfterProperty> preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletInvoice, double, QAfterProperty> amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletInvoice, bool, QAfterProperty> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletInvoice, bool, QAfterProperty> isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletInvoice, bool, QAfterProperty> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletInvoice, bool, QAfterProperty> isCancelledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletInvoice, int, QAfterProperty>
      timeUntilExpirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<WalletInvoice, bool, QAfterProperty> isExpiringSoonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }
}

extension WalletInvoiceQueryProperty2<R>
    on QueryBuilder<WalletInvoice, R, QAfterProperty> {
  QueryBuilder<WalletInvoice, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletInvoice, (R, String), QAfterProperty> invoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletInvoice, (R, String), QAfterProperty> bolt11Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletInvoice, (R, String), QAfterProperty>
      paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletInvoice, (R, int), QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletInvoice, (R, String?), QAfterProperty>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletInvoice, (R, InvoiceStatus), QAfterProperty>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletInvoice, (R, int), QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletInvoice, (R, int), QAfterProperty> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletInvoice, (R, int?), QAfterProperty> paidAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletInvoice, (R, String), QAfterProperty> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletInvoice, (R, String?), QAfterProperty>
      relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletInvoice, (R, String?), QAfterProperty> preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletInvoice, (R, double), QAfterProperty> amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletInvoice, (R, bool), QAfterProperty> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletInvoice, (R, bool), QAfterProperty> isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletInvoice, (R, bool), QAfterProperty> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletInvoice, (R, bool), QAfterProperty> isCancelledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletInvoice, (R, int), QAfterProperty>
      timeUntilExpirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<WalletInvoice, (R, bool), QAfterProperty>
      isExpiringSoonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }
}

extension WalletInvoiceQueryProperty3<R1, R2>
    on QueryBuilder<WalletInvoice, (R1, R2), QAfterProperty> {
  QueryBuilder<WalletInvoice, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, String), QOperations>
      invoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, String), QOperations> bolt11Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, String), QOperations>
      paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, int), QOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, String?), QOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, InvoiceStatus), QOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, int), QOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, int), QOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, int?), QOperations> paidAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, String), QOperations>
      walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, String?), QOperations>
      relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, String?), QOperations>
      preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, double), QOperations>
      amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, bool), QOperations> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, bool), QOperations> isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, bool), QOperations> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, bool), QOperations>
      isCancelledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, int), QOperations>
      timeUntilExpirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<WalletInvoice, (R1, R2, bool), QOperations>
      isExpiringSoonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }
}
