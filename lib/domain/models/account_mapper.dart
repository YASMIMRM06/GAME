import 'account_entity.dart';

class AccountMapper {
  static Map<String, dynamic> toMap(Account account) {
    return {
      'name': account.name,
      'email': account.email,
      'displayName': account.displayName,
      'createdAt': account.createdAt.toIso8601String(),
      'updatedAt': account.updatedAt.toIso8601String(),
      'level': account.level,
      'gold': account.gold,
      'gems': account.gems,
      'energy': account.energy,
    };
  }

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      name: map['name'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      level: map['level'] as int,
      gold: (map['gold'] as num).toDouble(),
      gems: map['gems'] as int,
      energy: map['energy'] as int,
    );
  }
}
