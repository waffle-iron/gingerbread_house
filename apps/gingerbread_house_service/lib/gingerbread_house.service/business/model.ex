defmodule GingerbreadHouse.Service.Business.Model do
    use Ecto.Schema
    import Ecto
    import Ecto.Changeset
    import Protecto
    @moduledoc """
      A model representing a business.

      ##Fields

      ###:id
      Is the unique reference to the business entry. Is an `integer`.

      ###:entity
      Is the entity the business belongs to. Is an `UUID`.

      ###:type
      Is the type of business. Is a `GingerbreadHouse.Service.Business.TypeEnum`.

      ###:name
      Is the name of the business. Is a `string`.

      ###:contact
      Is the contact of the business. Is a `string`.

      ###:country
      Is the country code (ISO 3166-1 alpha-2) indicating the country where the business
      is registered. Is a 2 character uppercase `string`.

      ###:address
      Is the address of the business. Is a `map`.

      ###:additional_details
      Any additional details to associate with the business. Is a `map`.
    """

    schema "businesses" do
        field :entity, Ecto.UUID
        field :type, GingerbreadHouse.Service.Business.TypeEnum
        field :name, :string
        field :contact, :string
        field :country, :string
        field :address, :map
        field :additional_details, :map
        timestamps()
    end

    @doc """
      Builds a changeset for insertion based on the `struct` and `params`.

      Enforces:
      * `entity` field is required
      * `type` field is required
      * `name` field is required
      * `contact` field is required
      * `country` field is required
      * `address` field is required
      * `country` field is length of 2
      * formats the `country` field as uppercase
      * checks uniqueness of the entity
    """
    def insert_changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:entity, :type, :name, :contact, :country, :address, :additional_details])
        |> validate_required([:entity, :type, :name, :contact, :country, :address])
        |> validate_length(:country, is: 2)
        |> format_uppercase(:country)
        |> unique_constraint(:entity)
    end

    @doc """
      Builds a changeset for update based on the `struct` and `params`.

      Enforces:
      * `entity` field is not empty
      * `type` field is not empty
      * `name` field is not empty
      * `contact` field is not empty
      * `country` field is not empty
      * `address` field is not empty
      * `country` field is length of 2
      * formats the `country` field as uppercase
      * checks uniqueness of the entity
    """
    def update_changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:entity, :type, :name, :contact, :country, :address, :additional_details])
        |> validate_emptiness(:entity)
        |> validate_emptiness(:type)
        |> validate_emptiness(:name)
        |> validate_emptiness(:contact)
        |> validate_emptiness(:country)
        |> validate_emptiness(:address)
        |> validate_length(:country, is: 2)
        |> format_uppercase(:country)
        |> unique_constraint(:entity)
    end
end
