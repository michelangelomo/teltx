defmodule Teltx.Decoder do
  @moduledoc """
  Decode incoming data from devices.
    - handle incoming authorization data
    - handle incoming GPS data
  """

  alias Teltx.Imei

  def handle(payload) do
    payload
    |> String.replace("\n", "")
    |> is_login?()
    |> manage()
  end

  def is_login?(payload) do
    payload
    |> get_first_8_char!()
    |> to_charlist()
    |> List.to_integer(16)
    |> authentication_payload?(payload)
  end

  defp get_first_8_char!(<<head::binary-size(8)>> <> _), do: head

  defp get_first_8_char!(_), do: "00000000"

  defp authentication_payload?(0, payload), do: {:error, :no_authentication, payload}

  defp authentication_payload?(_, payload), do: {:ok, :authentication, payload}

  defp manage({:ok, :authentication, payload}), do: Imei.extract(payload)

  defp manage({:error, :no_authentication, _}), do: nil
end
