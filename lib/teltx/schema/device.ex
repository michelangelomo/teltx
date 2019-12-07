defmodule Teltx.Schema.Device do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Query

  schema "devices" do
    field(:imei, :string)
    field(:project, :string)
  end

  def get_imei(imei) do
    from(d in __MODULE__, where: d.imei == ^imei, limit: 1)
  end
end
