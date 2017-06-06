defmodule GingerbreadHouse.BusinessDetails do
    @type t :: %{
        optional(:type) => :individual | :company,
        optional(:country) => String.t,
        optional(:name) => String.t,
        optional(:contact) => String.t,
        optional(:address) => %{ optional(String.t) => String.t },
        optional(:additional_details) => %{ optional(String.t) => String.t },
        optional(any) => any
    }

    @callback new(t) :: struct()

    def new(details = %{ country: country }) do
        atom_to_module(country).new(details)
    end

    @spec atom_to_module(String.t) :: atom
    defp atom_to_module(name) do
        String.to_atom(to_string(__MODULE__) <> "." <> format_as_module(name))
    end

    @spec format_as_module(String.t) :: String.t
    defp format_as_module(name) do
        name
        |> String.split(".")
        |> Enum.map(fn module ->
            String.split(module, "_") |> Enum.map(&String.capitalize(&1)) |> Enum.join
        end)
        |> Enum.join(".")
    end
end
