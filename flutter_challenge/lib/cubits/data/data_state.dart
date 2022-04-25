part of 'data_cubit.dart';

@immutable
abstract class DataState {
  final List<CategoryCubit> categoryCubits;
  const DataState(this.categoryCubits);
}

//TODO
class DataLoading extends DataState {
  DataLoading() : super([]);
}

class DataReady extends DataState {
  const DataReady(List<CategoryCubit> categoryCubits) : super(categoryCubits);
}
