defmodule GingerbreadHouse.Service.Business do
    alias GingerbreadHouse.BusinessDetails
    alias GingerbreadHouse.Service.Business
    require Logger
    import Ecto.Query

    @type uuid :: String.t
    @type representative :: { integer, Business.Representative.t }

    @spec create(uuid, struct()) :: :ok | { :error, String.t }
    def create(entity, details) do
        #todo: maybe add validated field, and set it to false, where a worker passes it along and attempts to validate it?
        case GingerbreadHouse.Service.Repo.insert(Business.Model.insert_changeset(%Business.Model{}, Map.put(BusinessDetails.to_map(details), :entity, entity))) do
            { :ok, _ } -> :ok
            { :error, changeset } ->
                Logger.debug("create business: #{inspect(changeset.errors)}")
                { :error, "Failed to create business" }
        end
    end

    @spec update(uuid, struct()) :: :ok | { :error, String.t }
    def update(entity, details) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :update, { :ok, _ } } <- { :update, GingerbreadHouse.Service.Repo.update(Business.Model.update_changeset(business, BusinessDetails.to_map(details))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :update, _ } -> { :error, "Failed to update business info" }
        end
    end

    @spec delete(uuid) :: :ok | { :error, String.t }
    def delete(entity) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :delete, { :ok, _ } } <- { :delete, GingerbreadHouse.Service.Repo.delete(business) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :delete, _ } -> { :error, "Failed to delete business info" }
        end
    end

    @spec get(uuid) :: { :ok, struct() } | { :error, String.t }
    def get(entity) do
        case GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) do
            business = %Business.Model{} -> { :ok, BusinessDetails.new(business) }
            _ -> { :error, "Business does not exist" }
        end
    end

    @spec representatives(uuid) :: [representative]
    def representatives(entity) do
        query = from business in Business.Model,
            where: business.entity == ^entity,
            join: representative in Business.Representative.Model, on: representative.business_id == business.id,
            select: { business.country, business.type, representative }

        GingerbreadHouse.Service.Repo.all(query)
        |> Enum.map(fn { country, type, representative} ->
            { representative.id, Business.Representative.new(%{ representative | birth_date: Date.from_iso8601!(Ecto.Date.to_iso8601(representative.birth_date)), address: BusinessDetails.new(%{ country: country, type: type, address: representative.address }).address }) }
        end)
    end

    @spec add_representative(uuid, Business.Representative.t) :: :ok | { :error, String.t }
    def add_representative(entity, representative) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :insert, { :ok, _ } } <- { :insert, GingerbreadHouse.Service.Repo.insert(Business.Representative.Model.insert_changeset(%Business.Representative.Model{}, Map.put(Business.Representative.to_map(representative), :business_id, business.id))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :insert, _ } -> { :error, "Failed to add representative" }
        end
    end

    @spec update_representative(uuid, integer, Business.Representative.t) :: :ok | { :error, String.t }
    def update_representative(entity, id, representative) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :representative, current_representative = %Business.Representative.Model{} } <- { :representative, GingerbreadHouse.Service.Repo.get_by(Business.Representative.Model, [id: id, business_id: business.id]) },
             { :update, { :ok, _ } } <- { :update, GingerbreadHouse.Service.Repo.update(Business.Representative.Model.update_changeset(current_representative, Business.Representative.to_map(representative))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :representative, _ } -> { :error, "Representative does not exist" }
            { :update, _ } -> { :error, "Failed to update representative" }
        end
    end

    @spec remove_representative(uuid, integer) :: :ok | { :error, String.t }
    def remove_representative(entity, id) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :representative, representative = %Business.Representative.Model{} } <- { :representative, GingerbreadHouse.Service.Repo.get_by(Business.Representative.Model, [id: id, business_id: business.id]) },
             { :delete, { :ok, _ } } <- { :delete, GingerbreadHouse.Service.Repo.delete(representative) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :representative, _ } -> { :error, "Representative does not exist" }
            { :delete, _ } -> { :error, "Failed to delete representative" }
        end
    end
end
