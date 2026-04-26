import '../../core/patterns/i_usecases.dart';
import '../../core/typedefs/types_defs.dart';

abstract interface class IGetAccountUseCase
    implements IUseCase<AccountResult, NoParams> {}

abstract interface class ISaveAccountUseCase
    implements IUseCase<VoidResult, AccountParams> {}

abstract interface class IDeleteAccountUseCase
    implements IUseCase<VoidResult, NoParams> {}

abstract interface class IUpdateAccountUseCase
    implements IUseCase<VoidResult, AccountParams> {}
