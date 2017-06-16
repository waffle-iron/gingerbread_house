defmodule GingerbreadHouse.API.Business_Test do
    use GingerbreadHouse.Service.Case

    alias GingerbreadHouse.API.Business
    alias GingerbreadHouse.BusinessDetails

    setup do
        {
            :ok, %{
                entity: Ecto.UUID.generate(),
                details: %BusinessDetails.AU.Individual{ name: "foo", contact: "foo@bar", abn: "123", address: %BusinessDetails.AU.Address{ street: "123 Bar St", city: "test", postcode: "1234", state: "testing" }, bank: %BusinessDetails.AU.Bank{ bsb: "100", account_number: "1" } },
                representative: %BusinessDetails.Representative{ name: "foo", birth_date: ~D[2017-01-01], address: %BusinessDetails.AU.Address{ street: "123 Bar St", city: "test", postcode: "1234", state: "testing" }, owner: false }
            }
        }
    end

    test "create business", %{ entity: entity, details: details } do
        assert :ok == Business.create(entity, details)
        assert { :ok, details } == Business.get(entity)
    end

    test "get non-existent business", %{ entity: entity, details: details } do
        assert { :error, "Business does not exist" } == Business.get(entity)
    end

    test "update business", %{ entity: entity, details: details } do
        :ok = Business.create(entity, details)
        assert :ok == Business.update(entity, %BusinessDetails.AU.Individual{ name: "bar" })
        assert { :ok, %{ details | name: "bar" } } == Business.get(entity)
    end

    test "update non-existent business", %{ entity: entity, details: details } do
        assert { :error, "Business does not exist" } == Business.update(entity, %BusinessDetails.AU.Individual{ name: "bar" })
    end

    test "delete business", %{ entity: entity, details: details } do
        :ok = Business.create(entity, details)
        assert :ok == Business.delete(entity)
        assert { :error, "Business does not exist" } == Business.get(entity)
    end

    test "delete non-existent business", %{ entity: entity, details: details } do
        assert { :error, "Business does not exist" } == Business.delete(entity)
    end

    test "add representative to business", %{ entity: entity, details: details, representative: representative } do
        :ok = Business.create(entity, details)
        assert [] == Business.Representative.all(entity)

        assert :ok == Business.Representative.create(entity, representative)
        assert [{ _, representative }] = Business.Representative.all(entity)
    end

    test "add representative to non-existent business", %{ entity: entity, details: details, representative: representative } do
        assert { :error, "Business does not exist" } == Business.Representative.create(entity, representative)
        assert [] = Business.Representative.all(entity)
    end

    test "get representative from business", %{ entity: entity, details: details, representative: representative } do
        :ok = Business.create(entity, details)
        :ok = Business.Representative.create(entity, representative)
        [{ id, _ }] = Business.Representative.all(entity)

        assert { :ok, representative } == Business.Representative.get(entity, id)
    end

    test "get representative from non-existent business", %{ entity: entity, details: details, representative: representative } do
        assert { :error, "Business does not exist" } == Business.Representative.get(entity, 1)
    end

    test "get non-existent representative from business", %{ entity: entity, details: details, representative: representative } do
        :ok = Business.create(entity, details)
        :ok = Business.Representative.create(entity, representative)
        [{ id, _ }] = Business.Representative.all(entity)

        assert { :error, "Representative does not exist" } == Business.Representative.get(entity, id + 1)
    end

    test "update representative from business", %{ entity: entity, details: details, representative: representative } do
        :ok = Business.create(entity, details)
        :ok = Business.Representative.create(entity, representative)
        [{ id, _ }] = Business.Representative.all(entity)

        assert :ok == Business.Representative.update(entity, id, %{ representative | name: "bar" })
        assert [{ id, %{ representative | name: "bar" } }] == Business.Representative.all(entity)
    end

    test "update representative from non-existent business", %{ entity: entity, details: details, representative: representative } do
        assert { :error, "Business does not exist" } == Business.Representative.update(entity, 1, %{ representative | name: "bar" })
    end

    test "update non-existent representative from business", %{ entity: entity, details: details, representative: representative } do
        :ok = Business.create(entity, details)
        :ok = Business.Representative.create(entity, representative)
        [{ id, _ }] = Business.Representative.all(entity)

        assert { :error, "Representative does not exist" } == Business.Representative.update(entity, id + 1, %{ representative | name: "bar" })
        assert [{ id, representative }] == Business.Representative.all(entity)
    end

    test "remove representative from business", %{ entity: entity, details: details, representative: representative } do
        :ok = Business.create(entity, details)
        :ok = Business.Representative.create(entity, representative)
        [{ id, _ }] = Business.Representative.all(entity)

        assert :ok == Business.Representative.delete(entity, id)
        assert [] == Business.Representative.all(entity)
    end

    test "remove representative from non-existent business", %{ entity: entity, details: details, representative: representative } do
        assert { :error, "Business does not exist" } == Business.Representative.delete(entity, 1)
    end

    test "remove non-existent representative from business", %{ entity: entity, details: details, representative: representative } do
        :ok = Business.create(entity, details)
        :ok = Business.Representative.create(entity, representative)
        [{ id, _ }] = Business.Representative.all(entity)

        assert { :error, "Representative does not exist" } == Business.Representative.delete(entity, id + 1)
        assert [{ id, representative }] == Business.Representative.all(entity)
    end
end
