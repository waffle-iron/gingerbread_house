defmodule GingerbreadHouse.BusinessDetails.Representative do
    @moduledoc """
      The representative's details.

      ##Fields

      ###:name
      Is the name of the representative. Is a `string`.

      ###:birth_date
      Is the date of birth of the representative. Is a `date`.

      ###:address
      Is the address of the representative, it must be in the format of the business
      address. Is a `struct`.

      ###:owner
      Whether the representative is an owner of the business (true) or not (false). Is
      a `boolean`.
    """
    defstruct [:name, :birth_date, :address, :owner]

    alias GingerbreadHouse.BusinessDetails
    alias GingerbreadHouse.BusinessDetails.Representative

    @type t :: %Representative{
        name: String.t,
        birth_date: Date.t,
        address: struct(),
        owner: boolean
    }

    def new(details) do
        %Representative{}
        |> new_name(details)
        |> new_birth_date(details)
        |> new_address(details)
        |> new_owner(details)
    end

    defp new_name(info, %{ name: name }), do: %{ info | name: name }
    defp new_name(info, _), do: info

    defp new_birth_date(info, %{ birth_date: birth_date }), do: %{ info | birth_date: birth_date }
    defp new_birth_date(info, _), do: info

    defp new_address(info, %{ address: address }), do: %{ info | address: address }
    defp new_address(info, _), do: info

    defp new_owner(info, %{ owner: owner }), do: %{ info | owner: owner }
    defp new_owner(info, _), do: info

    @spec to_map(t) :: %{ name: String.t, birth_date: Date.t, country: String.t, address: %{ optional(String.t) => String.t }, owner: boolean }
    def to_map(representative) do
        %{}
        |> set_name(representative)
        |> set_birth_date(representative)
        |> set_country(representative)
        |> set_address(representative)
        |> set_owner(representative)
    end

    defp set_name(details, %{ name: nil }), do: details
    defp set_name(details, %{ name: name }), do: Map.put(details, :name, name)

    defp set_birth_date(details, %{ birth_date: nil }), do: details
    defp set_birth_date(details, %{ birth_date: birth_date }), do: Map.put(details, :birth_date, birth_date)

    defp set_country(details, %{ address: nil }), do: details
    defp set_country(details, %{ address: address }), do: Map.put(details, :country, BusinessDetails.country(address))

    defp set_address(details, %{ address: nil }), do: details
    defp set_address(details, %{ address: address }), do: Map.put(details, :address, BusinessDetails.to_map(address))

    defp set_owner(details, %{ owner: nil }), do: details
    defp set_owner(details, %{ owner: owner }), do: Map.put(details, :owner, owner)
end
