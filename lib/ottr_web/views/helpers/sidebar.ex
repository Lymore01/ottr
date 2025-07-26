defmodule OttrWeb.Helpers.Sidebar do
  def sidebar_class("collapsed"), do: "w-[60px]"
  def sidebar_class("hover"), do: "w-[60px] hover:w-[220px]"
  def sidebar_class("expanded"), do: "w-[220px]"

  def label_class("collapsed"), do: "hidden"
  def label_class("expanded"), do: "inline"
  def label_class("hover"), do: "hidden group-hover:inline"

  def visibility_class("collapsed"), do: "hidden"
  def visibility_class("expanded"), do: "block"
  def visibility_class("hover"), do: "hidden group-hover:block"

  def nav_items do
    [
      # %{label: "Playground", href: "/dashboard", icon: :beaker},
      %{label: "Home", href: "/dashboard", icon: :home},
      %{label: "My Bursts", href: "/dashboard/workflows", icon: :arrows_right_left},
      %{label: "Integrations", href: "/dashboard/integrations", icon: :puzzle_piece},
      %{label: "Automations", href: "/dashboard/automations", icon: :sparkles},
      %{label: "Settings", href: "/dashboard/settings", icon: :cog_6_tooth},
      %{label: "Templates", href: "/dashboard/templates", icon: :document}
    ]
  end

  def current_path?(path, expected), do: String.starts_with?(path || "", expected)
end
