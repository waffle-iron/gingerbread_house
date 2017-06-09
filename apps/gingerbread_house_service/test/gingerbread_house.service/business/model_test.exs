defmodule GingerbreadHouse.Service.Business.ModelTest do
    use GingerbreadHouse.Service.Case

    alias GingerbreadHouse.Service.Business

    @valid_model %Business.Model{
        entity: Ecto.UUID.generate(),
        type: :company,
        name: "test pty ltd",
        contact: "+0123",
        country: "FR",
        address: %{ "street" => "123 test st", "city" => "foo" },
        additional_details: %{ "abn" => "1234" }
    }

    test "empty" do
        refute_change(%Business.Model{}, %{}, :insert_changeset)
    end

    test "only entity" do
        refute_change(%Business.Model{}, %{ entity: @valid_model.entity }, :insert_changeset)

        assert_change(@valid_model, %{ entity: Ecto.UUID.generate() }, :update_changeset)
    end

    test "only type" do
        refute_change(%Business.Model{}, %{ type: @valid_model.type }, :insert_changeset)

        assert_change(@valid_model, %{ type: :individual }, :update_changeset)
    end

    test "only name" do
        refute_change(%Business.Model{}, %{ name: @valid_model.name }, :insert_changeset)

        assert_change(@valid_model, %{ name: "foo" }, :update_changeset)
    end

    test "only contact" do
        refute_change(%Business.Model{}, %{ contact: @valid_model.contact }, :insert_changeset)

        assert_change(@valid_model, %{ contact: "+0000" }, :update_changeset)
    end

    test "only country" do
        refute_change(%Business.Model{}, %{ country: @valid_model.country }, :insert_changeset)

        assert_change(@valid_model, %{ country: "AU" }, :update_changeset)
    end

    test "only address" do
        refute_change(%Business.Model{}, %{ address: @valid_model.address }, :insert_changeset)

        assert_change(@valid_model, %{ address: %{ "street" => "123 foo st", "city" => "bar" } }, :update_changeset)
    end

    test "only additional_details" do
        refute_change(%Business.Model{}, %{ additional_details: @valid_model.additional_details }, :insert_changeset)

        assert_change(@valid_model, %{ additional_details: %{ "acn" => "1111" } }, :update_changeset)
    end

    test "without entity" do
        refute_change(@valid_model, %{ entity: nil }, :insert_changeset)
    end

    test "without type" do
        refute_change(@valid_model, %{ type: nil }, :insert_changeset)
    end

    test "without name" do
        refute_change(@valid_model, %{ name: nil }, :insert_changeset)
    end

    test "without contact" do
        refute_change(@valid_model, %{ contact: nil }, :insert_changeset)
    end

    test "without country" do
        refute_change(@valid_model, %{ country: nil }, :insert_changeset)
    end

    test "without address" do
        refute_change(@valid_model, %{ address: nil }, :insert_changeset)
    end

    test "without additional_details" do
        assert_change(@valid_model, %{ additional_details: nil }, :insert_changeset)
    end

    test "valid model" do
        assert_change(@valid_model, %{}, :insert_changeset)

        assert_change(@valid_model, %{}, :update_changeset)
    end

    test "country length" do
        refute_change(@valid_model, %{ country: "" }, :insert_changeset) |> assert_change_value(:country, nil)
        refute_change(@valid_model, %{ country: "A" }, :insert_changeset)
        assert_change(@valid_model, %{ country: "AU" }, :insert_changeset) |> assert_change_value(:country, "AU")
        refute_change(@valid_model, %{ country: "AUS" }, :insert_changeset)

        refute_change(@valid_model, %{ country: "" }, :update_changeset) |> assert_change_value(:country, nil)
        refute_change(@valid_model, %{ country: "A" }, :update_changeset)
        assert_change(@valid_model, %{ country: "AU" }, :update_changeset) |> assert_change_value(:country, "AU")
        refute_change(@valid_model, %{ country: "AUS" }, :update_changeset)
    end

    test "country casing" do
        assert_change(@valid_model, %{ country: "AU" }, :insert_changeset) |> assert_change_value(:country, "AU")
        assert_change(@valid_model, %{ country: "aU" }, :insert_changeset) |> assert_change_value(:country, "AU")
        assert_change(@valid_model, %{ country: "Au" }, :insert_changeset) |> assert_change_value(:country, "AU")
        assert_change(@valid_model, %{ country: "au" }, :insert_changeset) |> assert_change_value(:country, "AU")

        assert_change(@valid_model, %{ country: "AU" }, :update_changeset) |> assert_change_value(:country, "AU")
        assert_change(@valid_model, %{ country: "aU" }, :update_changeset) |> assert_change_value(:country, "AU")
        assert_change(@valid_model, %{ country: "Au" }, :update_changeset) |> assert_change_value(:country, "AU")
        assert_change(@valid_model, %{ country: "au" }, :update_changeset) |> assert_change_value(:country, "AU")
    end

    test "uniqueness" do
        entity = Ecto.UUID.generate()
        entity2 = Regex.replace(~r/[\da-f]/, entity, fn
            "0", _ -> "1"
            "1", _ -> "2"
            "2", _ -> "3"
            "3", _ -> "4"
            "4", _ -> "5"
            "5", _ -> "6"
            "6", _ -> "7"
            "7", _ -> "8"
            "8", _ -> "9"
            "9", _ -> "a"
            "a", _ -> "b"
            "b", _ -> "c"
            "c", _ -> "d"
            "d", _ -> "e"
            "e", _ -> "f"
            "f", _ -> "0"
        end)
        business = GingerbreadHouse.Service.Repo.insert!(Business.Model.insert_changeset(@valid_model, %{ entity: entity }))

        assert_change(@valid_model, %{ entity: entity }, :insert_changeset)
        |> assert_insert(:error)
        |> assert_error_value(:entity, { "has already been taken", [] })

        assert_change(@valid_model, %{ entity: entity2 }, :insert_changeset)
        |> assert_insert(:ok)
    end
end
