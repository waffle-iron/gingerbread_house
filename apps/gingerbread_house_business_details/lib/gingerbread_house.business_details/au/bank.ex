defmodule GingerbreadHouse.BusinessDetails.AU.Bank do
    @moduledoc """
      A struct representing an Australian bank account.

      ##Fields

      ###:bsb
      Is the BSB of the bank. Is a `string`.

      ###:account_number
      Is the account number for that bank account. Is a `string`.
    """

    defstruct [
        :bsb,
        :account_number
    ]
end
