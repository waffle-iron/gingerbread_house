defmodule GingerbreadHouse.Service.Repo.Migrations.Representative do
    use Ecto.Migration

    def change do
        create table(:representatives) do
            add :business_id, references(:businesses),
                null: false

            add :name, :string,
                null: false

            add :birth_date, :date,
                null: false

            add :country, :char,
                size: 2,
                null: false,
                comment: "The ISO 3166-1 alpha-2 code for the country"

            add :address, :map,
                null: false

            add :owner, :boolean,
                null: false

            timestamps()
        end
    end
end
