defmodule Raduga.Utils do
  @moduledoc """
  A small set of utilities
  """

  def generate_slug(),
    do: Integer.to_string(Enum.random(10_000..99_999)) <> "-" <> MnemonicSlugs.generate_slug(3)

  def generate_title(title), do: " - #{title}"

  def default_color(id), do: %{"id" => id, "hex" => "FAFAFA", "speed" => 0.5}
end
