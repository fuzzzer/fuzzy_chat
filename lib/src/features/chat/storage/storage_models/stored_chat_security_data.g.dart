// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_chat_security_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStoredChatSecurityDataCollection on Isar {
  IsarCollection<StoredChatSecurityData> get storedChatSecurityDatas =>
      this.collection();
}

const StoredChatSecurityDataSchema = CollectionSchema(
  name: r'StoredChatSecurityData',
  id: -616618316297658101,
  properties: {
    r'acceptanceFilePath': PropertySchema(
      id: 0,
      name: r'acceptanceFilePath',
      type: IsarType.string,
    ),
    r'chatId': PropertySchema(
      id: 1,
      name: r'chatId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'encryptedSymmetricKey': PropertySchema(
      id: 3,
      name: r'encryptedSymmetricKey',
      type: IsarType.string,
    ),
    r'invitationFilePath': PropertySchema(
      id: 4,
      name: r'invitationFilePath',
      type: IsarType.string,
    )
  },
  estimateSize: _storedChatSecurityDataEstimateSize,
  serialize: _storedChatSecurityDataSerialize,
  deserialize: _storedChatSecurityDataDeserialize,
  deserializeProp: _storedChatSecurityDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'chatId': IndexSchema(
      id: 1909629659142158609,
      name: r'chatId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chatId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _storedChatSecurityDataGetId,
  getLinks: _storedChatSecurityDataGetLinks,
  attach: _storedChatSecurityDataAttach,
  version: '3.1.0',
);

int _storedChatSecurityDataEstimateSize(
  StoredChatSecurityData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.acceptanceFilePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.chatId.length * 3;
  {
    final value = object.encryptedSymmetricKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.invitationFilePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _storedChatSecurityDataSerialize(
  StoredChatSecurityData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.acceptanceFilePath);
  writer.writeString(offsets[1], object.chatId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.encryptedSymmetricKey);
  writer.writeString(offsets[4], object.invitationFilePath);
}

StoredChatSecurityData _storedChatSecurityDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StoredChatSecurityData();
  object.acceptanceFilePath = reader.readStringOrNull(offsets[0]);
  object.chatId = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.encryptedSymmetricKey = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.invitationFilePath = reader.readStringOrNull(offsets[4]);
  return object;
}

P _storedChatSecurityDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _storedChatSecurityDataGetId(StoredChatSecurityData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _storedChatSecurityDataGetLinks(
    StoredChatSecurityData object) {
  return [];
}

void _storedChatSecurityDataAttach(
    IsarCollection<dynamic> col, Id id, StoredChatSecurityData object) {
  object.id = id;
}

extension StoredChatSecurityDataByIndex
    on IsarCollection<StoredChatSecurityData> {
  Future<StoredChatSecurityData?> getByChatId(String chatId) {
    return getByIndex(r'chatId', [chatId]);
  }

  StoredChatSecurityData? getByChatIdSync(String chatId) {
    return getByIndexSync(r'chatId', [chatId]);
  }

  Future<bool> deleteByChatId(String chatId) {
    return deleteByIndex(r'chatId', [chatId]);
  }

  bool deleteByChatIdSync(String chatId) {
    return deleteByIndexSync(r'chatId', [chatId]);
  }

  Future<List<StoredChatSecurityData?>> getAllByChatId(
      List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'chatId', values);
  }

  List<StoredChatSecurityData?> getAllByChatIdSync(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'chatId', values);
  }

  Future<int> deleteAllByChatId(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'chatId', values);
  }

  int deleteAllByChatIdSync(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'chatId', values);
  }

  Future<Id> putByChatId(StoredChatSecurityData object) {
    return putByIndex(r'chatId', object);
  }

  Id putByChatIdSync(StoredChatSecurityData object, {bool saveLinks = true}) {
    return putByIndexSync(r'chatId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByChatId(List<StoredChatSecurityData> objects) {
    return putAllByIndex(r'chatId', objects);
  }

  List<Id> putAllByChatIdSync(List<StoredChatSecurityData> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'chatId', objects, saveLinks: saveLinks);
  }
}

extension StoredChatSecurityDataQueryWhereSort
    on QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QWhere> {
  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StoredChatSecurityDataQueryWhere on QueryBuilder<
    StoredChatSecurityData, StoredChatSecurityData, QWhereClause> {
  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterWhereClause> chatIdEqualTo(String chatId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chatId',
        value: [chatId],
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterWhereClause> chatIdNotEqualTo(String chatId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StoredChatSecurityDataQueryFilter on QueryBuilder<
    StoredChatSecurityData, StoredChatSecurityData, QFilterCondition> {
  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'acceptanceFilePath',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'acceptanceFilePath',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'acceptanceFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'acceptanceFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'acceptanceFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'acceptanceFilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'acceptanceFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'acceptanceFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      acceptanceFilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'acceptanceFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      acceptanceFilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'acceptanceFilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'acceptanceFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> acceptanceFilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'acceptanceFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      chatIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      chatIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> chatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'encryptedSymmetricKey',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'encryptedSymmetricKey',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedSymmetricKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedSymmetricKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedSymmetricKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedSymmetricKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedSymmetricKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedSymmetricKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      encryptedSymmetricKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedSymmetricKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      encryptedSymmetricKeyMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedSymmetricKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedSymmetricKey',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> encryptedSymmetricKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedSymmetricKey',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'invitationFilePath',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'invitationFilePath',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invitationFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invitationFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invitationFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invitationFilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invitationFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invitationFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      invitationFilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invitationFilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
          QAfterFilterCondition>
      invitationFilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invitationFilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invitationFilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData,
      QAfterFilterCondition> invitationFilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invitationFilePath',
        value: '',
      ));
    });
  }
}

extension StoredChatSecurityDataQueryObject on QueryBuilder<
    StoredChatSecurityData, StoredChatSecurityData, QFilterCondition> {}

extension StoredChatSecurityDataQueryLinks on QueryBuilder<
    StoredChatSecurityData, StoredChatSecurityData, QFilterCondition> {}

extension StoredChatSecurityDataQuerySortBy
    on QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QSortBy> {
  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByAcceptanceFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptanceFilePath', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByAcceptanceFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptanceFilePath', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByEncryptedSymmetricKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedSymmetricKey', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByEncryptedSymmetricKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedSymmetricKey', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByInvitationFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invitationFilePath', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      sortByInvitationFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invitationFilePath', Sort.desc);
    });
  }
}

extension StoredChatSecurityDataQuerySortThenBy on QueryBuilder<
    StoredChatSecurityData, StoredChatSecurityData, QSortThenBy> {
  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByAcceptanceFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptanceFilePath', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByAcceptanceFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acceptanceFilePath', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByEncryptedSymmetricKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedSymmetricKey', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByEncryptedSymmetricKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedSymmetricKey', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByInvitationFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invitationFilePath', Sort.asc);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QAfterSortBy>
      thenByInvitationFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invitationFilePath', Sort.desc);
    });
  }
}

extension StoredChatSecurityDataQueryWhereDistinct
    on QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QDistinct> {
  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QDistinct>
      distinctByAcceptanceFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'acceptanceFilePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QDistinct>
      distinctByChatId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QDistinct>
      distinctByEncryptedSymmetricKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedSymmetricKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StoredChatSecurityData, StoredChatSecurityData, QDistinct>
      distinctByInvitationFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invitationFilePath',
          caseSensitive: caseSensitive);
    });
  }
}

extension StoredChatSecurityDataQueryProperty on QueryBuilder<
    StoredChatSecurityData, StoredChatSecurityData, QQueryProperty> {
  QueryBuilder<StoredChatSecurityData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StoredChatSecurityData, String?, QQueryOperations>
      acceptanceFilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'acceptanceFilePath');
    });
  }

  QueryBuilder<StoredChatSecurityData, String, QQueryOperations>
      chatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatId');
    });
  }

  QueryBuilder<StoredChatSecurityData, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<StoredChatSecurityData, String?, QQueryOperations>
      encryptedSymmetricKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedSymmetricKey');
    });
  }

  QueryBuilder<StoredChatSecurityData, String?, QQueryOperations>
      invitationFilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invitationFilePath');
    });
  }
}
