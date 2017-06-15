defmodule GingerbreadHouse.Service.Business.Representative.ModelTest do
    use GingerbreadHouse.Service.Case

    alias GingerbreadHouse.Service.Business.Representative

    @valid_model %Representative.Model{
        business_id: 1,
        name: "test",
        birth_date: ~D[2017-01-01],
        country: "FR",
        address: %{ "street" => "123 test st", "city" => "foo" },
        owner: false
    }

    test "empty" do
        refute_change(%Representative.Model{}, %{}, :insert_changeset)
    end

    test "only business" do
        refute_change(%Representative.Model{}, %{ business_id: @valid_model.business_id }, :insert_changeset)

        assert_change(@valid_model, %{ business_id: 0 }, :update_changeset)
    end

    test "only name" do
        refute_change(%Representative.Model{}, %{ name: @valid_model.name }, :insert_changeset)

        assert_change(@valid_model, %{ name: "foo" }, :update_changeset)
    end

    test "only birth date" do
        refute_change(%Representative.Model{}, %{ birth_date: @valid_model.birth_date }, :insert_changeset)

        assert_change(@valid_model, %{ birth_date: ~D[2017-01-01] }, :update_changeset)
    end

    test "only country" do
        refute_change(%Representative.Model{}, %{ country: @valid_model.country }, :insert_changeset)

        assert_change(@valid_model, %{ country: "AU" }, :update_changeset)
    end

    test "only address" do
        refute_change(%Representative.Model{}, %{ address: @valid_model.address }, :insert_changeset)

        assert_change(@valid_model, %{ address: %{ "street" => "123 foo st", "city" => "bar" } }, :update_changeset)
    end

    test "only owner" do
        refute_change(%Representative.Model{}, %{ owner: @valid_model.owner }, :insert_changeset)

        assert_change(@valid_model, %{ owner: true }, :update_changeset)
    end

    test "without business" do
        refute_change(@valid_model, %{ business_id: nil }, :insert_changeset)
    end

    test "without name" do
        refute_change(@valid_model, %{ name: nil }, :insert_changeset)
    end

    test "without birth date" do
        refute_change(@valid_model, %{ birth_date: nil }, :insert_changeset)
    end

    test "without country" do
        refute_change(@valid_model, %{ country: nil }, :insert_changeset)
    end

    test "without address" do
        refute_change(@valid_model, %{ address: nil }, :insert_changeset)
    end

    test "without owner" do
        refute_change(@valid_model, %{ owner: nil }, :insert_changeset)
    end

    test "valid model" do
        assert_change(@valid_model, %{}, :insert_changeset)

        assert_change(@valid_model, %{}, :update_changeset)
    end
end
