/// Base use case interface
/// [Type] is the return type
/// [Params] is the parameters type
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use case that doesn't require parameters
abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}
