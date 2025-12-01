// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetWalletTransactionCollection on Isar {
  IsarCollection<int, WalletTransaction> get walletTransactions =>
      this.collection();
}

const WalletTransactionSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'WalletTransaction',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'transactionId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'type',
        type: IsarType.byte,
        enumMap: {"incoming": 0, "outgoing": 1},
      ),
      IsarPropertySchema(
        name: 'status',
        type: IsarType.byte,
        enumMap: {"pending": 0, "confirmed": 1, "failed": 2, "expired": 3},
      ),
      IsarPropertySchema(
        name: 'amount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'fee',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'description',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'invoice',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'paymentHash',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'preimage',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'createdAt',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'confirmedAt',
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
        name: 'amountBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'feeBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'netAmount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'netAmountBTC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'isConfirmed',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isPending',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isFailed',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isExpired',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isIncoming',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isOutgoing',
        type: IsarType.bool,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'transactionId',
        properties: [
          "transactionId",
        ],
        unique: true,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, WalletTransaction>(
    serialize: serializeWalletTransaction,
    deserialize: deserializeWalletTransaction,
    deserializeProperty: deserializeWalletTransactionProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeWalletTransaction(IsarWriter writer, WalletTransaction object) {
  IsarCore.writeString(writer, 1, object.transactionId);
  IsarCore.writeByte(writer, 2, object.type.index);
  IsarCore.writeByte(writer, 3, object.status.index);
  IsarCore.writeLong(writer, 4, object.amount);
  IsarCore.writeLong(writer, 5, object.fee);
  {
    final value = object.description;
    if (value == null) {
      IsarCore.writeNull(writer, 6);
    } else {
      IsarCore.writeString(writer, 6, value);
    }
  }
  {
    final value = object.invoice;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  {
    final value = object.paymentHash;
    if (value == null) {
      IsarCore.writeNull(writer, 8);
    } else {
      IsarCore.writeString(writer, 8, value);
    }
  }
  {
    final value = object.preimage;
    if (value == null) {
      IsarCore.writeNull(writer, 9);
    } else {
      IsarCore.writeString(writer, 9, value);
    }
  }
  IsarCore.writeLong(writer, 10, object.createdAt);
  IsarCore.writeLong(writer, 11, object.confirmedAt ?? -9223372036854775808);
  IsarCore.writeString(writer, 12, object.walletId);
  {
    final value = object.relatedPubkey;
    if (value == null) {
      IsarCore.writeNull(writer, 13);
    } else {
      IsarCore.writeString(writer, 13, value);
    }
  }
  IsarCore.writeDouble(writer, 14, object.amountBTC);
  IsarCore.writeDouble(writer, 15, object.feeBTC);
  IsarCore.writeLong(writer, 16, object.netAmount);
  IsarCore.writeDouble(writer, 17, object.netAmountBTC);
  IsarCore.writeBool(writer, 18, object.isConfirmed);
  IsarCore.writeBool(writer, 19, object.isPending);
  IsarCore.writeBool(writer, 20, object.isFailed);
  IsarCore.writeBool(writer, 21, object.isExpired);
  IsarCore.writeBool(writer, 22, object.isIncoming);
  IsarCore.writeBool(writer, 23, object.isOutgoing);
  return object.id;
}

@isarProtected
WalletTransaction deserializeWalletTransaction(IsarReader reader) {
  final String _transactionId;
  _transactionId = IsarCore.readString(reader, 1) ?? '';
  final TransactionType _type;
  {
    if (IsarCore.readNull(reader, 2)) {
      _type = TransactionType.incoming;
    } else {
      _type = _walletTransactionType[IsarCore.readByte(reader, 2)] ??
          TransactionType.incoming;
    }
  }
  final TransactionStatus _status;
  {
    if (IsarCore.readNull(reader, 3)) {
      _status = TransactionStatus.pending;
    } else {
      _status = _walletTransactionStatus[IsarCore.readByte(reader, 3)] ??
          TransactionStatus.pending;
    }
  }
  final int _amount;
  _amount = IsarCore.readLong(reader, 4);
  final int _fee;
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      _fee = 0;
    } else {
      _fee = value;
    }
  }
  final String? _description;
  _description = IsarCore.readString(reader, 6);
  final String? _invoice;
  _invoice = IsarCore.readString(reader, 7);
  final String? _paymentHash;
  _paymentHash = IsarCore.readString(reader, 8);
  final String? _preimage;
  _preimage = IsarCore.readString(reader, 9);
  final int _createdAt;
  _createdAt = IsarCore.readLong(reader, 10);
  final int? _confirmedAt;
  {
    final value = IsarCore.readLong(reader, 11);
    if (value == -9223372036854775808) {
      _confirmedAt = null;
    } else {
      _confirmedAt = value;
    }
  }
  final String _walletId;
  _walletId = IsarCore.readString(reader, 12) ?? '';
  final String? _relatedPubkey;
  _relatedPubkey = IsarCore.readString(reader, 13);
  final object = WalletTransaction(
    transactionId: _transactionId,
    type: _type,
    status: _status,
    amount: _amount,
    fee: _fee,
    description: _description,
    invoice: _invoice,
    paymentHash: _paymentHash,
    preimage: _preimage,
    createdAt: _createdAt,
    confirmedAt: _confirmedAt,
    walletId: _walletId,
    relatedPubkey: _relatedPubkey,
  );
  object.id = IsarCore.readId(reader);
  return object;
}

@isarProtected
dynamic deserializeWalletTransactionProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      {
        if (IsarCore.readNull(reader, 2)) {
          return TransactionType.incoming;
        } else {
          return _walletTransactionType[IsarCore.readByte(reader, 2)] ??
              TransactionType.incoming;
        }
      }
    case 3:
      {
        if (IsarCore.readNull(reader, 3)) {
          return TransactionStatus.pending;
        } else {
          return _walletTransactionStatus[IsarCore.readByte(reader, 3)] ??
              TransactionStatus.pending;
        }
      }
    case 4:
      return IsarCore.readLong(reader, 4);
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
      return IsarCore.readString(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7);
    case 8:
      return IsarCore.readString(reader, 8);
    case 9:
      return IsarCore.readString(reader, 9);
    case 10:
      return IsarCore.readLong(reader, 10);
    case 11:
      {
        final value = IsarCore.readLong(reader, 11);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 12:
      return IsarCore.readString(reader, 12) ?? '';
    case 13:
      return IsarCore.readString(reader, 13);
    case 14:
      return IsarCore.readDouble(reader, 14);
    case 15:
      return IsarCore.readDouble(reader, 15);
    case 16:
      return IsarCore.readLong(reader, 16);
    case 17:
      return IsarCore.readDouble(reader, 17);
    case 18:
      return IsarCore.readBool(reader, 18);
    case 19:
      return IsarCore.readBool(reader, 19);
    case 20:
      return IsarCore.readBool(reader, 20);
    case 21:
      return IsarCore.readBool(reader, 21);
    case 22:
      return IsarCore.readBool(reader, 22);
    case 23:
      return IsarCore.readBool(reader, 23);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _WalletTransactionUpdate {
  bool call({
    required int id,
    String? transactionId,
    TransactionType? type,
    TransactionStatus? status,
    int? amount,
    int? fee,
    String? description,
    String? invoice,
    String? paymentHash,
    String? preimage,
    int? createdAt,
    int? confirmedAt,
    String? walletId,
    String? relatedPubkey,
    double? amountBTC,
    double? feeBTC,
    int? netAmount,
    double? netAmountBTC,
    bool? isConfirmed,
    bool? isPending,
    bool? isFailed,
    bool? isExpired,
    bool? isIncoming,
    bool? isOutgoing,
  });
}

class _WalletTransactionUpdateImpl implements _WalletTransactionUpdate {
  const _WalletTransactionUpdateImpl(this.collection);

  final IsarCollection<int, WalletTransaction> collection;

  @override
  bool call({
    required int id,
    Object? transactionId = ignore,
    Object? type = ignore,
    Object? status = ignore,
    Object? amount = ignore,
    Object? fee = ignore,
    Object? description = ignore,
    Object? invoice = ignore,
    Object? paymentHash = ignore,
    Object? preimage = ignore,
    Object? createdAt = ignore,
    Object? confirmedAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? amountBTC = ignore,
    Object? feeBTC = ignore,
    Object? netAmount = ignore,
    Object? netAmountBTC = ignore,
    Object? isConfirmed = ignore,
    Object? isPending = ignore,
    Object? isFailed = ignore,
    Object? isExpired = ignore,
    Object? isIncoming = ignore,
    Object? isOutgoing = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (transactionId != ignore) 1: transactionId as String?,
          if (type != ignore) 2: type as TransactionType?,
          if (status != ignore) 3: status as TransactionStatus?,
          if (amount != ignore) 4: amount as int?,
          if (fee != ignore) 5: fee as int?,
          if (description != ignore) 6: description as String?,
          if (invoice != ignore) 7: invoice as String?,
          if (paymentHash != ignore) 8: paymentHash as String?,
          if (preimage != ignore) 9: preimage as String?,
          if (createdAt != ignore) 10: createdAt as int?,
          if (confirmedAt != ignore) 11: confirmedAt as int?,
          if (walletId != ignore) 12: walletId as String?,
          if (relatedPubkey != ignore) 13: relatedPubkey as String?,
          if (amountBTC != ignore) 14: amountBTC as double?,
          if (feeBTC != ignore) 15: feeBTC as double?,
          if (netAmount != ignore) 16: netAmount as int?,
          if (netAmountBTC != ignore) 17: netAmountBTC as double?,
          if (isConfirmed != ignore) 18: isConfirmed as bool?,
          if (isPending != ignore) 19: isPending as bool?,
          if (isFailed != ignore) 20: isFailed as bool?,
          if (isExpired != ignore) 21: isExpired as bool?,
          if (isIncoming != ignore) 22: isIncoming as bool?,
          if (isOutgoing != ignore) 23: isOutgoing as bool?,
        }) >
        0;
  }
}

sealed class _WalletTransactionUpdateAll {
  int call({
    required List<int> id,
    String? transactionId,
    TransactionType? type,
    TransactionStatus? status,
    int? amount,
    int? fee,
    String? description,
    String? invoice,
    String? paymentHash,
    String? preimage,
    int? createdAt,
    int? confirmedAt,
    String? walletId,
    String? relatedPubkey,
    double? amountBTC,
    double? feeBTC,
    int? netAmount,
    double? netAmountBTC,
    bool? isConfirmed,
    bool? isPending,
    bool? isFailed,
    bool? isExpired,
    bool? isIncoming,
    bool? isOutgoing,
  });
}

class _WalletTransactionUpdateAllImpl implements _WalletTransactionUpdateAll {
  const _WalletTransactionUpdateAllImpl(this.collection);

  final IsarCollection<int, WalletTransaction> collection;

  @override
  int call({
    required List<int> id,
    Object? transactionId = ignore,
    Object? type = ignore,
    Object? status = ignore,
    Object? amount = ignore,
    Object? fee = ignore,
    Object? description = ignore,
    Object? invoice = ignore,
    Object? paymentHash = ignore,
    Object? preimage = ignore,
    Object? createdAt = ignore,
    Object? confirmedAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? amountBTC = ignore,
    Object? feeBTC = ignore,
    Object? netAmount = ignore,
    Object? netAmountBTC = ignore,
    Object? isConfirmed = ignore,
    Object? isPending = ignore,
    Object? isFailed = ignore,
    Object? isExpired = ignore,
    Object? isIncoming = ignore,
    Object? isOutgoing = ignore,
  }) {
    return collection.updateProperties(id, {
      if (transactionId != ignore) 1: transactionId as String?,
      if (type != ignore) 2: type as TransactionType?,
      if (status != ignore) 3: status as TransactionStatus?,
      if (amount != ignore) 4: amount as int?,
      if (fee != ignore) 5: fee as int?,
      if (description != ignore) 6: description as String?,
      if (invoice != ignore) 7: invoice as String?,
      if (paymentHash != ignore) 8: paymentHash as String?,
      if (preimage != ignore) 9: preimage as String?,
      if (createdAt != ignore) 10: createdAt as int?,
      if (confirmedAt != ignore) 11: confirmedAt as int?,
      if (walletId != ignore) 12: walletId as String?,
      if (relatedPubkey != ignore) 13: relatedPubkey as String?,
      if (amountBTC != ignore) 14: amountBTC as double?,
      if (feeBTC != ignore) 15: feeBTC as double?,
      if (netAmount != ignore) 16: netAmount as int?,
      if (netAmountBTC != ignore) 17: netAmountBTC as double?,
      if (isConfirmed != ignore) 18: isConfirmed as bool?,
      if (isPending != ignore) 19: isPending as bool?,
      if (isFailed != ignore) 20: isFailed as bool?,
      if (isExpired != ignore) 21: isExpired as bool?,
      if (isIncoming != ignore) 22: isIncoming as bool?,
      if (isOutgoing != ignore) 23: isOutgoing as bool?,
    });
  }
}

extension WalletTransactionUpdate on IsarCollection<int, WalletTransaction> {
  _WalletTransactionUpdate get update => _WalletTransactionUpdateImpl(this);

  _WalletTransactionUpdateAll get updateAll =>
      _WalletTransactionUpdateAllImpl(this);
}

sealed class _WalletTransactionQueryUpdate {
  int call({
    String? transactionId,
    TransactionType? type,
    TransactionStatus? status,
    int? amount,
    int? fee,
    String? description,
    String? invoice,
    String? paymentHash,
    String? preimage,
    int? createdAt,
    int? confirmedAt,
    String? walletId,
    String? relatedPubkey,
    double? amountBTC,
    double? feeBTC,
    int? netAmount,
    double? netAmountBTC,
    bool? isConfirmed,
    bool? isPending,
    bool? isFailed,
    bool? isExpired,
    bool? isIncoming,
    bool? isOutgoing,
  });
}

class _WalletTransactionQueryUpdateImpl
    implements _WalletTransactionQueryUpdate {
  const _WalletTransactionQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<WalletTransaction> query;
  final int? limit;

  @override
  int call({
    Object? transactionId = ignore,
    Object? type = ignore,
    Object? status = ignore,
    Object? amount = ignore,
    Object? fee = ignore,
    Object? description = ignore,
    Object? invoice = ignore,
    Object? paymentHash = ignore,
    Object? preimage = ignore,
    Object? createdAt = ignore,
    Object? confirmedAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? amountBTC = ignore,
    Object? feeBTC = ignore,
    Object? netAmount = ignore,
    Object? netAmountBTC = ignore,
    Object? isConfirmed = ignore,
    Object? isPending = ignore,
    Object? isFailed = ignore,
    Object? isExpired = ignore,
    Object? isIncoming = ignore,
    Object? isOutgoing = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (transactionId != ignore) 1: transactionId as String?,
      if (type != ignore) 2: type as TransactionType?,
      if (status != ignore) 3: status as TransactionStatus?,
      if (amount != ignore) 4: amount as int?,
      if (fee != ignore) 5: fee as int?,
      if (description != ignore) 6: description as String?,
      if (invoice != ignore) 7: invoice as String?,
      if (paymentHash != ignore) 8: paymentHash as String?,
      if (preimage != ignore) 9: preimage as String?,
      if (createdAt != ignore) 10: createdAt as int?,
      if (confirmedAt != ignore) 11: confirmedAt as int?,
      if (walletId != ignore) 12: walletId as String?,
      if (relatedPubkey != ignore) 13: relatedPubkey as String?,
      if (amountBTC != ignore) 14: amountBTC as double?,
      if (feeBTC != ignore) 15: feeBTC as double?,
      if (netAmount != ignore) 16: netAmount as int?,
      if (netAmountBTC != ignore) 17: netAmountBTC as double?,
      if (isConfirmed != ignore) 18: isConfirmed as bool?,
      if (isPending != ignore) 19: isPending as bool?,
      if (isFailed != ignore) 20: isFailed as bool?,
      if (isExpired != ignore) 21: isExpired as bool?,
      if (isIncoming != ignore) 22: isIncoming as bool?,
      if (isOutgoing != ignore) 23: isOutgoing as bool?,
    });
  }
}

extension WalletTransactionQueryUpdate on IsarQuery<WalletTransaction> {
  _WalletTransactionQueryUpdate get updateFirst =>
      _WalletTransactionQueryUpdateImpl(this, limit: 1);

  _WalletTransactionQueryUpdate get updateAll =>
      _WalletTransactionQueryUpdateImpl(this);
}

class _WalletTransactionQueryBuilderUpdateImpl
    implements _WalletTransactionQueryUpdate {
  const _WalletTransactionQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<WalletTransaction, WalletTransaction, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? transactionId = ignore,
    Object? type = ignore,
    Object? status = ignore,
    Object? amount = ignore,
    Object? fee = ignore,
    Object? description = ignore,
    Object? invoice = ignore,
    Object? paymentHash = ignore,
    Object? preimage = ignore,
    Object? createdAt = ignore,
    Object? confirmedAt = ignore,
    Object? walletId = ignore,
    Object? relatedPubkey = ignore,
    Object? amountBTC = ignore,
    Object? feeBTC = ignore,
    Object? netAmount = ignore,
    Object? netAmountBTC = ignore,
    Object? isConfirmed = ignore,
    Object? isPending = ignore,
    Object? isFailed = ignore,
    Object? isExpired = ignore,
    Object? isIncoming = ignore,
    Object? isOutgoing = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (transactionId != ignore) 1: transactionId as String?,
        if (type != ignore) 2: type as TransactionType?,
        if (status != ignore) 3: status as TransactionStatus?,
        if (amount != ignore) 4: amount as int?,
        if (fee != ignore) 5: fee as int?,
        if (description != ignore) 6: description as String?,
        if (invoice != ignore) 7: invoice as String?,
        if (paymentHash != ignore) 8: paymentHash as String?,
        if (preimage != ignore) 9: preimage as String?,
        if (createdAt != ignore) 10: createdAt as int?,
        if (confirmedAt != ignore) 11: confirmedAt as int?,
        if (walletId != ignore) 12: walletId as String?,
        if (relatedPubkey != ignore) 13: relatedPubkey as String?,
        if (amountBTC != ignore) 14: amountBTC as double?,
        if (feeBTC != ignore) 15: feeBTC as double?,
        if (netAmount != ignore) 16: netAmount as int?,
        if (netAmountBTC != ignore) 17: netAmountBTC as double?,
        if (isConfirmed != ignore) 18: isConfirmed as bool?,
        if (isPending != ignore) 19: isPending as bool?,
        if (isFailed != ignore) 20: isFailed as bool?,
        if (isExpired != ignore) 21: isExpired as bool?,
        if (isIncoming != ignore) 22: isIncoming as bool?,
        if (isOutgoing != ignore) 23: isOutgoing as bool?,
      });
    } finally {
      q.close();
    }
  }
}

extension WalletTransactionQueryBuilderUpdate
    on QueryBuilder<WalletTransaction, WalletTransaction, QOperations> {
  _WalletTransactionQueryUpdate get updateFirst =>
      _WalletTransactionQueryBuilderUpdateImpl(this, limit: 1);

  _WalletTransactionQueryUpdate get updateAll =>
      _WalletTransactionQueryBuilderUpdateImpl(this);
}

const _walletTransactionType = {
  0: TransactionType.incoming,
  1: TransactionType.outgoing,
};
const _walletTransactionStatus = {
  0: TransactionStatus.pending,
  1: TransactionStatus.confirmed,
  2: TransactionStatus.failed,
  3: TransactionStatus.expired,
};

extension WalletTransactionQueryFilter
    on QueryBuilder<WalletTransaction, WalletTransaction, QFilterCondition> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      idEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdGreaterThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdGreaterThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdLessThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdStartsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdEndsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      transactionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeEqualTo(
    TransactionType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeGreaterThan(
    TransactionType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeGreaterThanOrEqualTo(
    TransactionType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeLessThan(
    TransactionType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeLessThanOrEqualTo(
    TransactionType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      typeBetween(
    TransactionType lower,
    TransactionType upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower.index,
          upper: upper.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusEqualTo(
    TransactionStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusGreaterThan(
    TransactionStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusGreaterThanOrEqualTo(
    TransactionStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusLessThan(
    TransactionStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusLessThanOrEqualTo(
    TransactionStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      statusBetween(
    TransactionStatus lower,
    TransactionStatus upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower.index,
          upper: upper.index,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeGreaterThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeGreaterThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeLessThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceGreaterThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceLessThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceStartsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceEndsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      invoiceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashGreaterThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashLessThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashStartsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashEndsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      paymentHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageGreaterThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageLessThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageStartsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageEndsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 9,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      preimageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 9,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      createdAtBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      confirmedAtBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdGreaterThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdGreaterThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdLessThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdStartsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdEndsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      walletIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyGreaterThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyLessThan(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyStartsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyEndsWith(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      relatedPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCGreaterThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCGreaterThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCLessThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      amountBTCBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCGreaterThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCGreaterThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCLessThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      feeBTCBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountEqualTo(
    int value,
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 16,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 16,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 16,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 16,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 16,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCGreaterThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCGreaterThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCLessThan(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCLessThanOrEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      netAmountBTCBetween(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isConfirmedEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isPendingEqualTo(
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

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isFailedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 20,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isExpiredEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 21,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isIncomingEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 22,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterFilterCondition>
      isOutgoingEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 23,
          value: value,
        ),
      );
    });
  }
}

extension WalletTransactionQueryObject
    on QueryBuilder<WalletTransaction, WalletTransaction, QFilterCondition> {}

extension WalletTransactionQuerySortBy
    on QueryBuilder<WalletTransaction, WalletTransaction, QSortBy> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByTransactionIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy> sortByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByInvoice({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByInvoiceDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPaymentHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPaymentHashDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPreimage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        9,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByPreimageDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        9,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByWalletId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByWalletIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByRelatedPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByRelatedPubkeyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByFeeBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByFeeBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByNetAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsIncoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsIncomingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsOutgoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      sortByIsOutgoingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, sort: Sort.desc);
    });
  }
}

extension WalletTransactionQuerySortThenBy
    on QueryBuilder<WalletTransaction, WalletTransaction, QSortThenBy> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByTransactionIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy> thenByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByInvoice({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByInvoiceDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPaymentHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPaymentHashDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPreimage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByPreimageDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByWalletId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByWalletIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByRelatedPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByRelatedPubkeyDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByFeeBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByFeeBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByNetAmountBTCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsIncoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsIncomingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsOutgoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterSortBy>
      thenByIsOutgoingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, sort: Sort.desc);
    });
  }
}

extension WalletTransactionQueryWhereDistinct
    on QueryBuilder<WalletTransaction, WalletTransaction, QDistinct> {
  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByInvoice({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByPaymentHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByPreimage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByWalletId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByRelatedPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByFeeBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByNetAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByNetAmountBTC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByIsConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByIsPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(21);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByIsIncoming() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(22);
    });
  }

  QueryBuilder<WalletTransaction, WalletTransaction, QAfterDistinct>
      distinctByIsOutgoing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(23);
    });
  }
}

extension WalletTransactionQueryProperty1
    on QueryBuilder<WalletTransaction, WalletTransaction, QProperty> {
  QueryBuilder<WalletTransaction, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletTransaction, String, QAfterProperty>
      transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletTransaction, TransactionType, QAfterProperty>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletTransaction, TransactionStatus, QAfterProperty>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletTransaction, int, QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletTransaction, int, QAfterProperty> feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletTransaction, String?, QAfterProperty>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletTransaction, String?, QAfterProperty> invoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletTransaction, String?, QAfterProperty>
      paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletTransaction, String?, QAfterProperty> preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletTransaction, int, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletTransaction, int?, QAfterProperty> confirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletTransaction, String, QAfterProperty> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletTransaction, String?, QAfterProperty>
      relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletTransaction, double, QAfterProperty> amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletTransaction, double, QAfterProperty> feeBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletTransaction, int, QAfterProperty> netAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletTransaction, double, QAfterProperty>
      netAmountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletTransaction, bool, QAfterProperty> isConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<WalletTransaction, bool, QAfterProperty> isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<WalletTransaction, bool, QAfterProperty> isFailedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<WalletTransaction, bool, QAfterProperty> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<WalletTransaction, bool, QAfterProperty> isIncomingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<WalletTransaction, bool, QAfterProperty> isOutgoingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}

extension WalletTransactionQueryProperty2<R>
    on QueryBuilder<WalletTransaction, R, QAfterProperty> {
  QueryBuilder<WalletTransaction, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletTransaction, (R, String), QAfterProperty>
      transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletTransaction, (R, TransactionType), QAfterProperty>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletTransaction, (R, TransactionStatus), QAfterProperty>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletTransaction, (R, int), QAfterProperty> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletTransaction, (R, int), QAfterProperty> feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletTransaction, (R, String?), QAfterProperty>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletTransaction, (R, String?), QAfterProperty>
      invoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletTransaction, (R, String?), QAfterProperty>
      paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletTransaction, (R, String?), QAfterProperty>
      preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletTransaction, (R, int), QAfterProperty>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletTransaction, (R, int?), QAfterProperty>
      confirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletTransaction, (R, String), QAfterProperty>
      walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletTransaction, (R, String?), QAfterProperty>
      relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletTransaction, (R, double), QAfterProperty>
      amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletTransaction, (R, double), QAfterProperty>
      feeBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletTransaction, (R, int), QAfterProperty>
      netAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletTransaction, (R, double), QAfterProperty>
      netAmountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletTransaction, (R, bool), QAfterProperty>
      isConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<WalletTransaction, (R, bool), QAfterProperty>
      isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<WalletTransaction, (R, bool), QAfterProperty>
      isFailedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<WalletTransaction, (R, bool), QAfterProperty>
      isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<WalletTransaction, (R, bool), QAfterProperty>
      isIncomingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<WalletTransaction, (R, bool), QAfterProperty>
      isOutgoingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}

extension WalletTransactionQueryProperty3<R1, R2>
    on QueryBuilder<WalletTransaction, (R1, R2), QAfterProperty> {
  QueryBuilder<WalletTransaction, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, String), QOperations>
      transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, TransactionType), QOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, TransactionStatus), QOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, int), QOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, int), QOperations> feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, String?), QOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, String?), QOperations>
      invoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, String?), QOperations>
      paymentHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, String?), QOperations>
      preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, int), QOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, int?), QOperations>
      confirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, String), QOperations>
      walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, String?), QOperations>
      relatedPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, double), QOperations>
      amountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, double), QOperations>
      feeBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, int), QOperations>
      netAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, double), QOperations>
      netAmountBTCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, bool), QOperations>
      isConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, bool), QOperations>
      isPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, bool), QOperations>
      isFailedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, bool), QOperations>
      isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, bool), QOperations>
      isIncomingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<WalletTransaction, (R1, R2, bool), QOperations>
      isOutgoingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }
}
