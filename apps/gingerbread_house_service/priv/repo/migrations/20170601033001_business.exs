defmodule GingerbreadHouse.Service.Repo.Migrations.Business do
    use Ecto.Migration

    def change do
        create table(:businesses) do
            add :entity, :uuid,
                null: false

            add :type, :string,
                null: false

            add :name, :string,
                null: false

            add :contact, :string,
                null: false

            add :country, :char,
                size: 2,
                null: false,
                comment: "The ISO 3166-1 alpha-2 code for the country"

            add :address, :string,
                null: false

            timestamps()
        end

        create index(:businesses, [:entity], unique: true)
    end
end
