defmodule GingerbreadHouse.API.Business.Representative do
    @moduledoc """
      Handles the management of business representatives.
    """

    @service GingerbreadHouse.Service.Business
    @entity_type :representative

    @type t :: %Representative{
        name: String.t,
        birth_date: Date.t,
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
        GenServer.call(@service, { :get, { entity, id }, @entity_type})
    end

    @doc """
      Get the details for all representatives of a business.
    """
    @spec all(uuid) :: [representative]
    def all(entity) do
        GenServer.call(@service, { :all, { entity }, @entity_type})
    end

    @doc """
      Create a new representative for a business.
    """
    @spec create(uuid, t) :: :ok | { :error, String.t }
    def create(entity, representative) do
        GenServer.call(@service, { :create, { entity, representative }, @entity_type})
    end

    @doc """
      Update the details of a business representative entry.
    """
    @spec update(uuid, integer, t) :: :ok | { :error, String.t }
    def update(entity, id, representative) do
        GenServer.call(@service, { :update, { entity, id, representative }, @entity_type})
    end

    @doc """
      Delete a business representative entry.
    """
    @spec delete(uuid, integer) :: :ok | { :error, String.t }
    def delete(entity, id) do
        GenServer.call(@service, { :delete, { entity, id }, @entity_type})
    end
end
