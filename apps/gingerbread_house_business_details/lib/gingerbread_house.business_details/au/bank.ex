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

    alias GingerbreadHouse.BusinessDetails.AU.Bank

    @type t :: %Bank{
        bsb: String.t,
        account_number: String.t
    }
end
