defmodule GingerbreadHouse.Service.Business.Representative.Model do
    use Ecto.Schema
    import Ecto
    import Ecto.Changeset
    import Protecto
    @moduledoc """
      A model representing a representative from the business.

      ##Fields

      ###:id
      Is the unique reference to the business entry. Is an `integer`.

      ###:business_id
      Is the reference to the business that this individual is a representative of.
      Is an `integer` to `GingerbreadHouse.Service.Business.Model`.

      ###:name
      Is the name of the individual. Is a `string`.

      ###:birth_date
      Is the individual's date of birth. Is a `date`.

      ###:address
      Is the address of the individual. Is a `string`.

      ###:owner
      Indicates whether the individual is an owner or not. Is a `boolean`.
    """

    schema "representatives" do
        belongs_to :business, GingerbreadHouse.Service.Business.Model
        field :name, :string
        field :birth_date, Ecto.Date
        field :address, :string
        field :owner, :boolean
        timestamps()
    end

    @doc """
      Builds a changeset for insertion based on the `struct` and `params`.

      Enforces:
      * `business_id` field is required
      * `name` field is required
      * `birth_date` field is required
      * `address` field is required
      * `owner` field is required
      * `business_id` field is associated with a business in `GingerbreadHouse.Service.Business.Model`
    """
    def insert_changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:business_id, :name, :birth_date, :address, :owner])
        |> validate_required([:business_id, :name, :birth_date, :address, :owner])
        |> assoc_constraint(:business)
    end

    @doc """
      Builds a changeset for update based on the `struct` and `params`.

      Enforces:
      * `business_id` field is not empty
      * `name` field is not empty
      * `birth_date` field is not empty
      * `address` field is not empty
      * `owner` field is not empty
      * `business_id` field is associated with a business in `GingerbreadHouse.Service.Business.Model`

    """
    def update_changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:business_id, :name, :birth_date, :address, :owner])
        |> validate_emptiness(:business_id)
        |> validate_emptiness(:name)
        |> validate_emptiness(:birth_date)
        |> validate_emptiness(:address)
        |> validate_emptiness(:owner)
        |> assoc_constraint(:business)
    end
end
