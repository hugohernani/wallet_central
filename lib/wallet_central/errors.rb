module WalletCentral
  class MissingRequiredParamsError < RuntimeError; end
  class DuplicateAccountError < RuntimeError; end
  class AccountNotFoundError < RuntimeError; end
end
