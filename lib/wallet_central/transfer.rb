module WalletCentral
  class Transfer
    USD_BRL_RATE = 3.16
    USD_EUR_RATE = 0.8
    RATE_TYPES = ["USD_BRL_RATE", "USD_EUR_RATE"]
    USD_CURRENCY = 'USD'
    BRL_CURRENCY = 'BRL'
    EUR_CURRENCY = 'EUR'
    ALLOWED_CURRENCIES = [USD_CURRENCY, BRL_CURRENCY, EUR_CURRENCY]

    class << self
      def transfer(giver_wallet, taker_wallet, amount, currency = nil)
        verify_allowed_currencies!(giver_wallet.currency, taker_wallet.currency, currency = currency || taker_wallet.currency)
        verify_amount_limits!(BigDecimal.new(giver_wallet.amount), amount = BigDecimal.new(amount.to_s))
        converted_amount = calculate_and_convert_if_needed(giver_wallet.currency,
                                                           amount,
                                                           currency)
        giver_wallet.debit(amount)
        taker_wallet.credit(converted_amount)
      end

      def rates
        Hash[:usd_to_brl_rate, USD_BRL_RATE, :usd_to_eur_rate, USD_EUR_RATE]
      end

      def set_rate(rate_type, rate)
        fail UnknownCurrencyRateError unless RATE_TYPES.include?(rate_type)
        remove_const(rate_type)
        const_set(:"#{rate_type}", rate)
      end

      private
      # usd, #eur, nil
      def verify_allowed_currencies!(giver_currency, taker_currency, currency)
        currency = currency || taker_currency
        fail CurrencyNotSupportedError, "Currency #{currency} is not supported." unless ALLOWED_CURRENCIES.include?(currency.upcase)
        not_transferable_currency = giver_currency !~ /^#{currency}$/i && taker_currency !~ /^#{currency}$/i
        fail WalletsWithoutCurrencyError, "Given wallets do not have this currency: #{currency}" if not_transferable_currency
      end

      def verify_amount_limits!(giver_amount, transfer_amount)
        if giver_amount < transfer_amount
          fail InsufficientAmountError, "Given wallet does not have enough amount to be transfered"
        end
      end

      def calculate_and_convert_if_needed(wallet_currency, transfer_amount, currency)
        return amount if wallet_currency =~ /^#{currency}$/i
        apply_conversion(wallet_currency, transfer_amount, currency)
      end

      # brl eur
      def apply_conversion(wallet_currency, transfer_amount, currency)
        wallet_currency, currency = [wallet_currency.upcase, currency.upcase]
        if indirect_transfer?(wallet_currency, currency)
          # Convert to dollar and then to given currency
          (transfer_amount / const_get(:"USD_#{wallet_currency}_RATE")) * const_get(:"USD_#{currency}_RATE")
        else
          wallet_currency =~ /^USD$/i ? transfer_amount * const_get(:"USD_#{currency}_RATE") : const_get(:"USD_#{currency}_RATE") / transfer_amount
        end
      end

      def indirect_transfer?(currency_one, currency_two)
        currency_one =~ /^BRL$/i && currency_two =~ /^EUR$/i ||
        currency_one =~ /^EUR$/i && currency_two =~ /^BRL$/i
      end
    end
  end
end
