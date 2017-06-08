defmodule GingerbreadHouse.BusinessDetails.AU.Company do
    defstruct [
        :name,
        :contact,
        :address,
        :abn,
        :acn,
        :bank
    ]

    alias GingerbreadHouse.BusinessDetails.AU.Address
    alias GingerbreadHouse.BusinessDetails.AU.Bank
    alias GingerbreadHouse.BusinessDetails.AU.Company

    @behaviour GingerbreadHouse.BusinessDetails

    def new(details) do
        %Company{}
        |> new_name(details)
        |> new_contact(details)
        |> new_address(details)
        |> new_abn(details)
        |> new_acn(details)
        |> new_bank(details)
    end

    defp new_name(info, %{ name: name }), do: %{ info | name: name }
    defp new_name(info, _), do: info

    defp new_contact(info, %{ contact: contact }), do: %{ info | contact: contact }
    defp new_contact(info, _), do: info

    defp new_address(info, %{ address: %{ "street" => street, "city" => city, "postcode" => postcode, "state" => state } }), do: %{ info | address: %Address{ street: street, city: city, postcode: postcode, state: state } }
    defp new_address(info, _), do: info

    defp new_abn(info, %{ additional_details: %{ "abn" => abn } }), do: %{ info | abn: abn }
    defp new_abn(info, _), do: info

    defp new_acn(info, %{ additional_details: %{ "acn" => acn } }), do: %{ info | acn: acn }
    defp new_acn(info, _), do: info

    defp new_bank(info, %{ additional_details: %{ "bank" => %{ "bsb" => bsb, "account_number" => account_number } } }), do: %{ info | bank: %Bank{ bsb: bsb, account_number: account_number } }
    defp new_bank(info, _), do: info

    defimpl GingerbreadHouse.BusinessDetails.Mapper, for: Company do
        def to_map(info) do
            %{ type: :company, country: "AU" }
            |> set_name(info)
            |> set_contact(info)
            |> set_address(info)
            |> set_abn(info)
            |> set_acn(info)
            |> set_bank(info)
        end

        defp set_name(details, %{ name: nil }), do: details
        defp set_name(details, %{ name: name }), do: Map.put(details, :name, name)

        defp set_contact(details, %{ contact: nil }), do: details
        defp set_contact(details, %{ contact: contact }), do: Map.put(details, :contact, contact)

        defp set_address(details, %{ address: nil }), do: details
        defp set_address(details, %{ address: %Address{ street: street, city: city, postcode: postcode, state: state } }), do: Map.put(details, :address, %{ "street" => street, "city" => city, "postcode" => postcode, "state" => state })

        defp set_abn(details, %{ abn: nil }), do: details
        defp set_abn(details = %{ additional_details: additional_details }, %{ abn: abn }), do: Map.put(details, :additional_details, Map.put(additional_details, "abn", abn))
        defp set_abn(details, %{ abn: abn }), do: Map.put(details, :additional_details, %{ "abn" => abn })

        defp set_acn(details, %{ acn: nil }), do: details
        defp set_acn(details = %{ additional_details: additional_details }, %{ acn: acn }), do: Map.put(details, :additional_details, Map.put(additional_details, "acn", acn))
        defp set_acn(details, %{ acn: acn }), do: Map.put(details, :additional_details, %{ "acn" => acn })

        defp set_bank(details, %{ bank: nil }), do: details
        defp set_bank(details = %{ additional_details: additional_details }, %{ bank: %Bank{ bsb: bsb, account_number: account_number } }), do: Map.put(details, :additional_details, Map.put(additional_details, "bank", %{ "bsb" => bsb, "account_number" => account_number }))
        defp set_bank(details, %{ bank: %Bank{ bsb: bsb, account_number: account_number } }), do: Map.put(details, :additional_details, %{ "bank" => %{ "bsb" => bsb, "account_number" => account_number } })
    end
end
