defmodule Teltx.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :imei, :string
      add :project, :string
    end
  end
end
