defmodule GingerbreadHouse.BusinessDetails.AU.Company do
    defstruct [
        :name,
        :contact,
        :street, :suburb, :postcode, :state,
        :abn,
        :acn,
        :bank
    ]
end
