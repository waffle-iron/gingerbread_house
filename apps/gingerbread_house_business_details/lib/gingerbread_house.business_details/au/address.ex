defmodule GingerbreadHouse.BusinessDetails.AU.Address do
    @moduledoc """
      A struct representing an Australian address.

      ##Fields

      ###:street
      Is the street part of the address. Is a `string`.

      ###:city
      Is the city part of the address. Is a `string`.

      ###:postcode
      Is the postal code part of the address. Is a `string`.

      ###:state
      Is the state part of the address. Is a `string`.
    """

    defstruct [
        :street,
        :city,
        :postcode,
        :state
    ]

    alias GingerbreadHouse.BusinessDetails.AU.Address

    @type t :: %Address{
        street: String.t,
        city: String.t,
        postcode: String.t,
        state: String.t
    }

    defimpl GingerbreadHouse.BusinessDetails.Mapper, for: Address do
        def to_map(%{ street: street, city: city, postcode: postcode, state: state }), do: %{ "street" => street, "city" => city, "postcode" => postcode, "state" => state }
    end
end
