import '../../core/typedefs/types_defs.dart';

abstract interface class IAccountFacadeUseCases {
  Future<AccountResult> getAccount(NoParams params);
  Future<VoidResult> saveAccount(AccountParams params);
  Future<VoidResult> updateAccount(AccountParams params);
  Future<VoidResult> deleteAccount(NoParams params);
}