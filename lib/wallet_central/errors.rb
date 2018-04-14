module WalletCentral
  class MissingRequiredParamsError < RuntimeError; end
  class DuplicateAccountError < RuntimeError; end
  class AccountNotFoundError < RuntimeError; end
  class DuplicateWalletError < RuntimeError; end
  class WalletNotFoundError < RuntimeError; end
  class CurrencyNotSupportedError < RuntimeError; end
  class WalletsWithoutCurrencyError < RuntimeError; end
  class InsufficientAmountError < RuntimeError; end
  class UnknownCurrencyRateError < RuntimeError; end
end
