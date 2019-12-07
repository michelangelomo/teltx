defmodule Teltx.Imei do
  @moduledoc """
  """
  alias Teltx.Schema.Device
  alias Teltx.Repo

  @spec extract(String.t()) :: tuple()
  def extract(payload) do
    payload
    |> remove_first_4_char!()
    |> Base.decode16!(case: :mixed)
    |> Device.get_imei()
    |> Repo.one()
    |> is_valid?()
  end

  @spec remove_first_4_char!(binary()) :: binary()
  defp remove_first_4_char!(<<_::binary-size(4)>> <> rest), do: rest

  @spec is_valid?(map() | nil) :: tuple()
  defp is_valid?(nil), do: {:error, :invalid_imei}

  defp is_valid?(%Teltx.Schema.Device{imei: imei}), do: {:authenticated, imei}
end
