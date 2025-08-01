defmodule OttrWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use OttrWeb, :controller` and
  `use OttrWeb, :live_view`.
  """
  use OttrWeb, :html
  import OttrWeb.Dashboard.{Sidebar, Topbar}
  import OttrWeb.Ui.DotGradient

  embed_templates "layouts/*"
end
