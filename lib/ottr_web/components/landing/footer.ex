defmodule OttrWeb.Landing.Footer do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def footer(assigns) do
    ~H"""
    <footer class="bg-[#073127] text-white px-6 sm:px-16 pt-20 pb-10">
      <div class="max-w-7xl mx-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10">
        <div>
          <h2 class="text-2xl font-bold text-white">Ottr.</h2>

          <p class="mt-4 text-sm text-zinc-300 max-w-xs">
            Effortless automation built for teams who want to save time and build smarter.
          </p>
        </div>

    <!-- Product Links -->
        <div>
          <h3 class="text-sm font-semibold text-zinc-100 uppercase tracking-wide mb-4">Product</h3>

          <ul class="space-y-2 text-sm text-zinc-300">
            <li><a href="#" class="hover:text-white transition">Features</a></li>

            <li><a href="#" class="hover:text-white transition">Pricing</a></li>

            <li><a href="#" class="hover:text-white transition">Integrations</a></li>

            <li><a href="#" class="hover:text-white transition">Changelog</a></li>
          </ul>
        </div>

    <!-- Company Links -->
        <div>
          <h3 class="text-sm font-semibold text-zinc-100 uppercase tracking-wide mb-4">Company</h3>

          <ul class="space-y-2 text-sm text-zinc-300">
            <li><a href="#" class="hover:text-white transition">About Us</a></li>

            <li><a href="#" class="hover:text-white transition">Careers</a></li>

            <li><a href="#" class="hover:text-white transition">Blog</a></li>

            <li><a href="#" class="hover:text-white transition">Support</a></li>
          </ul>
        </div>

    <!-- Social Media -->
        <div>
          <h3 class="text-sm font-semibold text-zinc-100 uppercase tracking-wide mb-4">More</h3>

          <ul class="space-y-2 text-sm text-zinc-300">
            <li>
              <a
                href="https://trackify-dev.vercel.app"
                class="hover:text-white transition"
                aria-label="Trackify"
                target="_blank"
                ref="noreferrer noopener"
              >
                Trackify
              </a>
            </li>
          </ul>
        </div>
      </div>

      <%!-- creator --%>
      <div class="mt-16 border-t border-zinc-700 pt-8 w-full flex flex-col sm:flex-row justify-between items-center gap-6 text-sm text-zinc-400">
        <div class="flex items-center gap-3 text-center sm:text-left">
          <img
            src="https://avatars.githubusercontent.com/u/130097627?v=4"
            alt="Kelly Limo"
            class="w-10 h-10 rounded-full object-cover"
          />
          <p>
            👋 Hey curious mind! I'm <span class="text-white font-medium">Kelly Limo</span>, the creator of Ottr.<br class="sm:hidden" />
            Come see what I'm building on
            <a
              href="https://github.com/Lymore01"
              target="_blank"
              class="underline hover:text-white transition"
            >
              GitHub
            </a>
          </p>
        </div>

        <p>© 2025 Ottr Inc. All rights reserved.</p>
      </div>
    </footer>
    """
  end
end
