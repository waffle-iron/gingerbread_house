defmodule GingerbreadHouse.Service.Business.Representative do
    @moduledoc """
      Handles the management of business representatives.
    """

    alias GingerbreadHouse.BusinessDetails
    alias GingerbreadHouse.Service.Business
    alias GingerbreadHouse.Service.Business.Representative
    require Logger
    import Ecto.Query

    @type uuid :: String.t
    @type representative :: { integer, BusinessDetails.Representative.t }

    @doc """
      Get the details of the business representative entry.
    """
    @spec get(uuid, integer) :: { :ok, BusinessDetails.Representative.t } | { :error, String.t }
    def get(entity, id) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :representative, representative = %Representative.Model{} } <- { :representative, GingerbreadHouse.Service.Repo.get_by(Representative.Model, [id: id, business_id: business.id]) } do
                { :ok, BusinessDetails.Representative.new(%{ representative | birth_date: Date.from_iso8601!(Ecto.Date.to_iso8601(representative.birth_date)), address: BusinessDetails.new(%{ country: representative.country, type: business.type, address: representative.address }).address }) }
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
            { representative.id, BusinessDetails.Representative.new(%{ representative | birth_date: Date.from_iso8601!(Ecto.Date.to_iso8601(representative.birth_date)), address: BusinessDetails.new(%{ country: representative.country, type: type, address: representative.address }).address }) }
        end)
    end

    @doc """
      Create a new representative for a business.
    """
    @spec create(uuid, BusinessDetails.Representative.t) :: :ok | { :error, String.t }
    def create(entity, representative) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :insert, { :ok, _ } } <- { :insert, GingerbreadHouse.Service.Repo.insert(Representative.Model.insert_changeset(%Representative.Model{}, Map.put(BusinessDetails.Representative.to_map(representative), :business_id, business.id))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :insert, _ } -> { :error, "Failed to add representative" }
        end
    end

    @doc """
      Update the details of a business representative entry.
    """
    @spec update(uuid, integer, BusinessDetails.Representative.t) :: :ok | { :error, String.t }
    def update(entity, id, representative) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :representative, current_representative = %Representative.Model{} } <- { :representative, GingerbreadHouse.Service.Repo.get_by(Representative.Model, [id: id, business_id: business.id]) },
             { :update, { :ok, _ } } <- { :update, GingerbreadHouse.Service.Repo.update(Representative.Model.update_changeset(current_representative, BusinessDetails.Representative.to_map(representative))) } do
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
end
