defmodule GingerbreadHouse.BusinessDetailsTest do
    use ExUnit.Case

    alias GingerbreadHouse.BusinessDetails

    describe "AU business" do
        test "individual to_map/1" do
            assert %{
                country: "AU",
                type: :individual
            } == BusinessDetails.to_map(%BusinessDetails.AU.Individual{})

            assert %{
                country: "AU",
                type: :individual,
                name: "test"
            } == BusinessDetails.to_map(%BusinessDetails.AU.Individual{ name: "test" })

            assert %{
                country: "AU",
                type: :individual,
                additional_details: %{
                    "abn" => "123"
                }
            } == BusinessDetails.to_map(%BusinessDetails.AU.Individual{abn: "123"})

            assert %{
                country: "AU",
                type: :individual,
                name: "test",
                contact: "foo@bar",
                address: %{ "street" => "123 test", "city" => "Testville", "postcode" => "1234", "state" => "Foo" },
                additional_details: %{
                    "abn" => "123",
                    "bank" => %{ "bsb" => "555", "account_number" => "1" }
                }
            } == BusinessDetails.to_map(%BusinessDetails.AU.Individual{
                name: "test",
                contact: "foo@bar",
                address: %BusinessDetails.AU.Address{ street: "123 test", city: "Testville", postcode: "1234", state: "Foo" },
                abn: "123",
                bank: %BusinessDetails.AU.Bank{ bsb: "555", account_number: "1" }
            })
        end

        test "individual new/1" do
            assert BusinessDetails.new(%{
                country: "AU",
                type: :individual
            }) == %BusinessDetails.AU.Individual{}

            assert BusinessDetails.new(%{
                country: "AU",
                type: :individual,
                name: "test"
            }) == %BusinessDetails.AU.Individual{ name: "test" }

            assert BusinessDetails.new(%{
                country: "AU",
                type: :individual,
                additional_details: %{
                    "abn" => "123"
                }
            }) == %BusinessDetails.AU.Individual{abn: "123"}

            assert BusinessDetails.new(%{
                country: "AU",
                type: :individual,
                name: "test",
                contact: "foo@bar",
                address: %{ "street" => "123 test", "city" => "Testville", "postcode" => "1234", "state" => "Foo" },
                additional_details: %{
                    "abn" => "123",
                    "bank" => %{ "bsb" => "555", "account_number" => "1" }
                }
            }) == %BusinessDetails.AU.Individual{
                name: "test",
                contact: "foo@bar",
                address: %BusinessDetails.AU.Address{ street: "123 test", city: "Testville", postcode: "1234", state: "Foo" },
                abn: "123",
                bank: %BusinessDetails.AU.Bank{ bsb: "555", account_number: "1" }
            }
        end

        test "company to_map/1" do
            assert %{
                country: "AU",
                type: :company
            } == BusinessDetails.to_map(%BusinessDetails.AU.Company{})

            assert %{
                country: "AU",
                type: :company,
                name: "test"
            } == BusinessDetails.to_map(%BusinessDetails.AU.Company{ name: "test" })

            assert %{
                country: "AU",
                type: :company,
                additional_details: %{
                    "abn" => "123"
                }
            } == BusinessDetails.to_map(%BusinessDetails.AU.Company{abn: "123"})

            assert %{
                country: "AU",
                type: :company,
                name: "test",
                contact: "foo@bar",
                address: %{ "street" => "123 test", "city" => "Testville", "postcode" => "1234", "state" => "Foo" },
                additional_details: %{
                    "abn" => "123",
                    "acn" => "999",
                    "bank" => %{ "bsb" => "555", "account_number" => "1" }
                }
            } == BusinessDetails.to_map(%BusinessDetails.AU.Company{
                name: "test",
                contact: "foo@bar",
                address: %BusinessDetails.AU.Address{ street: "123 test", city: "Testville", postcode: "1234", state: "Foo" },
                abn: "123",
                acn: "999",
                bank: %BusinessDetails.AU.Bank{ bsb: "555", account_number: "1" }
            })
        end

        test "company new/1" do
            assert BusinessDetails.new(%{
                country: "AU",
                type: :company
            }) == %BusinessDetails.AU.Company{}

            assert BusinessDetails.new(%{
                country: "AU",
                type: :company,
                name: "test"
            }) == %BusinessDetails.AU.Company{ name: "test" }

            assert BusinessDetails.new(%{
                country: "AU",
                type: :company,
                additional_details: %{
                    "abn" => "123"
                }
            }) == %BusinessDetails.AU.Company{abn: "123"}

            assert BusinessDetails.new(%{
                country: "AU",
                type: :company,
                name: "test",
                contact: "foo@bar",
                address: %{ "street" => "123 test", "city" => "Testville", "postcode" => "1234", "state" => "Foo" },
                additional_details: %{
                    "abn" => "123",
                    "acn" => "999",
                    "bank" => %{ "bsb" => "555", "account_number" => "1" }
                }
            }) == %BusinessDetails.AU.Company{
                name: "test",
                contact: "foo@bar",
                address: %BusinessDetails.AU.Address{ street: "123 test", city: "Testville", postcode: "1234", state: "Foo" },
                abn: "123",
                acn: "999",
                bank: %BusinessDetails.AU.Bank{ bsb: "555", account_number: "1" }
            }
        end
    end
end
