import 'package:flutter/material.dart';
import 'package:flutter_challenge/cubits/data/data_cubit.dart';
import 'package:flutter_challenge/models/item_category.dart';
import 'package:flutter_challenge/repositories/data_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataRepository extends Mock implements DataRepository {}

void main() {
  MockDataRepository repository;

  setUp(() {});

  group('GetCategories', (() {
    repository = MockDataRepository();
    test('', () {
      when(() => repository.getCategories()).thenAnswer(
        (_) => Stream.fromIterable([
          [
            ItemCategory(name: 'category1', color: Colors.red.value),
            ItemCategory(name: 'category2', color: Colors.blue.value)
          ]
        ]),
      );

      final cubit = DataCubit(repository: repository);

      expectLater(cubit, emits(const DataState()));
    });
  }));
}
