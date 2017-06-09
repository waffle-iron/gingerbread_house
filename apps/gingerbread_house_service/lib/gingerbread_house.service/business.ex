defmodule GingerbreadHouse.Service.Business do
    alias GingerbreadHouse.BusinessDetails
    alias GingerbreadHouse.Service.Business
    require Logger
    import Ecto.Query

    @type uuid :: String.t

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
        query = from business in Business.Model,
            where: business.entity == ^entity

        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.one(query) },
             { :update, { :ok, _ } } <- { :update, GingerbreadHouse.Service.Repo.update(Business.Model.update_changeset(business, BusinessDetails.to_map(details))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :update, _ } -> { :error, "Failed to update business info" }
        end
    end

    @spec delete(uuid) :: :ok | { :error, String.t }
    def delete(entity) do
        query = from business in Business.Model,
            where: business.entity == ^entity

        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.one(query) },
             { :delete, { :ok, _ } } <- { :delete, GingerbreadHouse.Service.Repo.delete(business) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :delete, _ } -> { :error, "Failed to delete business info" }
        end
    end
end
