defmodule Teltx.Decoder do
  @moduledoc """
  Decode incoming data from devices.
    - handle incoming authorization data
    - handle incoming GPS data
  """

  alias Teltx.Imei

  def handle(payload) do
    payload
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

  defp get_first_8_char!(<<head :: binary-size(8)>> <> rest), do: head

  defp get_first_8_char!(_), do: "00000000"

  defp authentication_payload?(0, payload), do: {:error, :no_authentication, payload}

  defp authentication_payload?(_, payload), do: {:ok, :authentication, payload}

  defp manage({:ok, :authentication, payload}), do: {:authenticated, Imei.extract(payload)}

  defp manage({:error, :no_authentication, payload}), do: nil

end
