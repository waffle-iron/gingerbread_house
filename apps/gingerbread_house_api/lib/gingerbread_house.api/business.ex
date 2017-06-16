defmodule GingerbreadHouse.API.Business do
    @moduledoc """
      Handles the management of business details.
    """

    @service GingerbreadHouse.Service.Business
    @entity_type :business

    @type uuid :: String.t

    @doc """
      Create a new business entry.

      The entity should be the unique ID to reference this business.
    """
    @spec create(uuid, struct()) :: :ok | { :error, String.t }
    def create(entity, details) do
        GenServer.call(@service, { :create, { entity, details }, @entity_type })
    end

    @doc """
      Update a business entry.

      To update only certain business details, leave the other details for the business as `nil`.
    """
    @spec update(uuid, struct()) :: :ok | { :error, String.t }
    def update(entity, details) do
        GenServer.call(@service, { :update, { entity, details }, @entity_type })
    end

    @doc """
      Delete a business entry.
    """
    @spec delete(uuid) :: :ok | { :error, String.t }
    def delete(entity) do
        GenServer.call(@service, { :delete, { entity }, @entity_type })
    end

    @doc """
      Get the details of a given business entry.
    """
    @spec get(uuid) :: { :ok, struct() } | { :error, String.t }
    def get(entity) do
        GenServer.call(@serice, { :get, { entity }, @entity_type })
    end
end
