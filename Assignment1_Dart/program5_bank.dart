class BankAccount {
  int? _accountNumber;
  double? _balance;
  static int totalAccountCount = 0;

  BankAccount(this._accountNumber, this._balance) {
    totalAccountCount = totalAccountCount + 1;
  }

  double deposite(double amount) {
    print("You have deposite $amount");
    return _balance ?? 0 + amount;
  }

  double withdraw(double amount) {
    if (_balance! >= amount) {
      print("You have withdraw $amount");

      return _balance! - amount;
    } else {
      print("You bank balance is $_balance\n You cannot remove $amount");
    }
    return 0;
  }

  static int totalAccounts() {
    return totalAccountCount;
  }
}

void main() {
  BankAccount bankAC1 = BankAccount(9876543, null);

  print(bankAC1.deposite(500));
  print(bankAC1.withdraw(8500));

  print("Total bank accounts=${BankAccount.totalAccounts()}");
  BankAccount bankAC2 = BankAccount(9976543, 10000);

  print(bankAC2.deposite(500));
  print(bankAC2.withdraw(800));

  print("Total bank accounts=${BankAccount.totalAccounts()}");
}
