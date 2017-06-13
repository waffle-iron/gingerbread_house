defmodule GingerbreadHouse.Service.BusinessTest do
    use GingerbreadHouse.Service.Case

    alias GingerbreadHouse.Service.Business
    alias GingerbreadHouse.BusinessDetails

    setup do
        {
            :ok, %{
                entity: Ecto.UUID.generate(),
                details: %BusinessDetails.AU.Individual{ name: "foo", contact: "foo@bar", abn: "123", address: %BusinessDetails.AU.Address{ street: "123 Bar St", city: "test", postcode: "1234", state: "testing" }, bank: %BusinessDetails.AU.Bank{ bsb: "100", account_number: "1" } }
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
end
