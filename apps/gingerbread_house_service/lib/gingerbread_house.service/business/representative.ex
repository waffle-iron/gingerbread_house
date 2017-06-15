defmodule GingerbreadHouse.Service.Business.Representative do
    @moduledoc """
      Handles the management of business representatives.

      The `Representative` struct is the representative's details.

      ##Fields

      ###:name
      Is the name of the representative. Is a `string`.

      ###:birth_date
      Is the date of birth of the representative. Is a `date`.

      ###:country
      The country the address is in. Takes the form of a country code (ISO 3166-1 alpha-2)
      indicating the country where the business is registered. Is a 2 character uppercase
      `string`.

      ###:address
      Is the address of the representative, it must be in the format of the business
      address. Is a `struct`.

      ###:owner
      Whether the representative is an owner of the business (true) or not (false). Is
      a `boolean`.
    """
    defstruct [:name, :birth_date, :country, :address, :owner]

    alias GingerbreadHouse.BusinessDetails
    alias GingerbreadHouse.Service.Business
    alias GingerbreadHouse.Service.Business.Representative
    require Logger
    import Ecto.Query

    @type t :: %Representative{
        name: String.t,
        birth_date: Date.t,
        country: String.t,
        address: struct(),
        owner: boolean
    }
    @type uuid :: String.t
    @type representative :: { integer, t }

    @doc """
      Get the details of the business representative entry.
    """
    @spec get(uuid, integer) :: { :ok, t } | { :error, String.t }
    def get(entity, id) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :representative, representative = %Representative.Model{} } <- { :representative, GingerbreadHouse.Service.Repo.get_by(Representative.Model, [id: id, business_id: business.id]) } do
                { :ok, new(%{ representative | birth_date: Date.from_iso8601!(Ecto.Date.to_iso8601(representative.birth_date)), address: BusinessDetails.new(%{ country: business.country, type: business.type, address: representative.address }).address }) }
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :representative, _ } -> { :error, "Representative does not exist" }
        end
    end

    @doc """
      Get the details for all representatives of a business.
    """
    @spec all(uuid) :: [representative]
    def all(entity) do
        query = from business in Business.Model,
            where: business.entity == ^entity,
            join: representative in Representative.Model, on: representative.business_id == business.id,
            select: { business.country, business.type, representative }

        GingerbreadHouse.Service.Repo.all(query)
        |> Enum.map(fn { country, type, representative} ->
            { representative.id, new(%{ representative | birth_date: Date.from_iso8601!(Ecto.Date.to_iso8601(representative.birth_date)), address: BusinessDetails.new(%{ country: representative.country, type: type, address: representative.address }).address }) }
        end)
    end

    @doc """
      Create a new representative for a business.
    """
    @spec create(uuid, t) :: :ok | { :error, String.t }
    def create(entity, representative) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :insert, { :ok, _ } } <- { :insert, GingerbreadHouse.Service.Repo.insert(Representative.Model.insert_changeset(%Representative.Model{}, Map.put(to_map(representative), :business_id, business.id))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :insert, _ } -> { :error, "Failed to add representative" }
        end
    end

    @doc """
      Update the details of a business representative entry.
    """
    @spec update(uuid, integer, t) :: :ok | { :error, String.t }
    def update(entity, id, representative) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :representative, current_representative = %Representative.Model{} } <- { :representative, GingerbreadHouse.Service.Repo.get_by(Representative.Model, [id: id, business_id: business.id]) },
             { :update, { :ok, _ } } <- { :update, GingerbreadHouse.Service.Repo.update(Representative.Model.update_changeset(current_representative, to_map(representative))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :representative, _ } -> { :error, "Representative does not exist" }
            { :update, _ } -> { :error, "Failed to update representative" }
        end
    end

    @doc """
      Delete a business representative entry.
    """
    @spec delete(uuid, integer) :: :ok | { :error, String.t }
    def delete(entity, id) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :representative, representative = %Representative.Model{} } <- { :representative, GingerbreadHouse.Service.Repo.get_by(Representative.Model, [id: id, business_id: business.id]) },
             { :delete, { :ok, _ } } <- { :delete, GingerbreadHouse.Service.Repo.delete(representative) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :representative, _ } -> { :error, "Representative does not exist" }
            { :delete, _ } -> { :error, "Failed to delete representative" }
        end
    end

    defp new(details) do
        %Representative{}
        |> new_name(details)
        |> new_birth_date(details)
        |> new_country(details)
        |> new_address(details)
        |> new_owner(details)
    end

    defp new_name(info, %{ name: name }), do: %{ info | name: name }
    defp new_name(info, _), do: info

    defp new_birth_date(info, %{ birth_date: birth_date }), do: %{ info | birth_date: birth_date }
    defp new_birth_date(info, _), do: info

    defp new_country(info, %{ country: country }), do: %{ info | country: country }
    defp new_country(info, _), do: info

    defp new_address(info, %{ address: address }), do: %{ info | address: address }
    defp new_address(info, _), do: info

    defp new_owner(info, %{ owner: owner }), do: %{ info | owner: owner }
    defp new_owner(info, _), do: info

    @spec to_map(t) :: %{ name: String.t, birth_date: Date.t, address: %{ optional(String.t) => String.t }, owner: boolean }
    defp to_map(representative) do
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

    defp set_country(details, %{ country: nil }), do: details
    defp set_country(details, %{ country: country }), do: Map.put(details, :country, country)

    defp set_address(details, %{ address: nil }), do: details
    defp set_address(details, %{ address: address }), do: Map.put(details, :address, BusinessDetails.to_map(address))

    defp set_owner(details, %{ owner: nil }), do: details
    defp set_owner(details, %{ owner: owner }), do: Map.put(details, :owner, owner)
end
