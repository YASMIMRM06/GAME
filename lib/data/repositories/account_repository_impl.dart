import '../../core/typedefs/types_defs.dart';
import 'account_repository_interface.dart';
import '../services/account_local_storage_interface.dart';
import '../../domain/models/account_entity.dart';

/// implementação do repositório para Account

final class AccountRepositoryImpl implements IAccountRepository {
  final IAccountLocalStorage _localStorage;

  AccountRepositoryImpl({
    required IAccountLocalStorage localStorage,
  }) : _localStorage = localStorage;

  @override
  Future<AccountResult> getAccount() {
    return _localStorage.getAccount(); 
  }

  @override
  Future<VoidResult> deleteAccount() {
    return _localStorage.deleteAccount();
  }

  @override
  Future<VoidResult> saveAccount(Account account) {
    return _localStorage.saveAccount(account);
  }
  
  @override
  Future<VoidResult> updateAccount(Account account) {
    return _localStorage.updateAccount(account);
  }
}


