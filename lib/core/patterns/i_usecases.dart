abstract interface class IUseCase<T, Params extends Object?> {
  Future<T> call(Params params);
}

abstract interface class IStreamUseCase<T, Params extends Object?> {
  Stream<T> call(Params params);
}
