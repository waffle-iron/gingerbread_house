defmodule GingerbreadHouse.BusinessDetails do
    @moduledoc """
      Handle conversion between general purpose map and type specific business struct.
    """

    @type generic_map :: %{ optional(String.t) => String.t }

    @type t :: %{
        required(:type) => :individual | :company,
        required(:country) => String.t,
        optional(:name) => String.t,
        optional(:contact) => String.t,
        optional(:address) => generic_map,
        optional(:additional_details) => generic_map,
        optional(any) => any
    }

    @callback new(t) :: struct()

    @doc """
      Create a business struct from the given map info.

      Country and type fields of the map must be specified. The other fields are optional.
    """
    @spec new(t) :: struct()
    def new(details = %{ country: country, type: type }) do
        localised_module(country, type).new(details)
    end

    defprotocol Mapper do
        @spec to_map(any) :: BusinessDetails.t | BusinessDetails.generic_map
        def to_map(details)
    end

    @doc """
      Convert a business struct or element to a general purpose map.
    """
    @spec to_map(struct()) :: t | generic_map
    def to_map(details) do
        Mapper.to_map(details)
    end

    @spec localised_module(String.t, atom) :: String.t
    defp localised_module(country, type) do
        String.to_atom(to_string(__MODULE__) <> "." <> String.upcase(country) <> "." <> format_as_module(to_string(type)))
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
