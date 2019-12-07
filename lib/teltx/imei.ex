defmodule Teltx.Imei do

  def extract(payload) do
    payload
    |> String.replace("\n", "")
    |> remove_first_4_char!()
    |> Base.decode16!(case: :mixed)
    |> String.to_integer
  end

  defp remove_first_4_char!(<<head :: binary-size(4)>> <> rest), do: rest

end
