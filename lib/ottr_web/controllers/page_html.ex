defmodule OttrWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use OttrWeb, :html
  import OttrWeb.Landing.{Navbar, Hero, Features, Integrations, Testimonial, Stats, Cta, Footer}

  embed_templates "page_html/*"
end
