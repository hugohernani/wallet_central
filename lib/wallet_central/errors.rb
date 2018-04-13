module WalletCentral
  class MissingRequiredParamsError < RuntimeError; end
  class DuplicateAccountError < RuntimeError; end
  class AccountNotFoundError < RuntimeError; end
  class DuplicateWalletError < RuntimeError; end
  class WalletNotFoundError < RuntimeError; end
end
