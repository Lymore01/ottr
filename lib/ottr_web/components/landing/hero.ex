defmodule OttrWeb.Landing.Hero do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Landing.{CtaButtons, Partners}

  def hero(assigns) do
    ~H"""
    <div class="w-full h-full flex flex-col">
      <section
        class="relative py-4 sm:py-8 xl:py-12 overflow-hidden"
        style="
    background-color: #EBEDE8;
    background-image:
      linear-gradient(rgba(0, 0, 0, 0.05) 1px, transparent 1px),
      linear-gradient(to right, rgba(0, 0, 0, 0.05) 1px, transparent 1px),
      radial-gradient(circle at center, rgba(235,237,232, 1) 0%, rgba(235,237,232, 1) 40%, rgba(235,237,232, 0) 85%);
    background-size: 40px 40px, 40px 40px, 100% 100%;
    background-position: center center;
    background-repeat: repeat;
    mask-image: radial-gradient(circle at center, black 20%, black 60%, transparent 100%);
    -webkit-mask-image: radial-gradient(circle at center, black 20%, black 60%, transparent 100%);
    "
      >
        <div
          class="absolute inset-12 pointer-events-none z-10"
          style="mask-image: none; -webkit-mask-image: none;"
        >
          <svg
            id="slack"
            class="absolute top-10 left-5 w-[54px] h-[54px] opacity-70 drop-shadow-subtle animate-float-medium"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 54 54"
          >
            <g fill="none" fill-rule="evenodd">
              <path
                fill="#36C5F0"
                d="M19.712.133a5.381 5.381 0 0 0-5.376 5.387 5.381 5.381 0 0 0 5.376 5.386h5.376V5.52A5.381 5.381 0 0 0 19.712.133m0 14.365H5.376A5.381 5.381 0 0 0 0 19.884a5.381 5.381 0 0 0 5.376 5.387h14.336a5.381 5.381 0 0 0 5.376-5.387 5.381 5.381 0 0 0-5.376-5.386"
              >
              </path>

              <path
                fill="#2EB67D"
                d="M53.76 19.884a5.381 5.381 0 0 0-5.376-5.386 5.381 5.381 0 0 0-5.376 5.386v5.387h5.376a5.381 5.381 0 0 0 5.376-5.387m-14.336 0V5.52A5.381 5.381 0 0 0 34.048.133a5.381 5.381 0 0 0-5.376 5.387v14.364a5.381 5.381 0 0 0 5.376 5.387 5.381 5.381 0 0 0 5.376-5.387"
              >
              </path>

              <path
                fill="#ECB22E"
                d="M34.048 54a5.381 5.381 0 0 0 5.376-5.387 5.381 5.381 0 0 0-5.376-5.386h-5.376v5.386A5.381 5.381 0 0 0 34.048 54m0-14.365h14.336a5.381 5.381 0 0 0 5.376-5.386 5.381 5.381 0 0 0-5.376-5.387H34.048a5.381 5.381 0 0 0-5.376 5.387 5.381 5.381 0 0 0 5.376 5.386"
              >
              </path>

              <path
                fill="#E01E5A"
                d="M0 34.249a5.381 5.381 0 0 0 5.376 5.386 5.381 5.381 0 0 0 5.376-5.386v-5.387H5.376A5.381 5.381 0 0 0 0 34.25m14.336-.001v14.364A5.381 5.381 0 0 0 19.712 54a5.381 5.381 0 0 0 5.376-5.387V34.25a5.381 5.381 0 0 0-5.376-5.387 5.381 5.381 0 0 0-5.376 5.387"
              >
              </path>
            </g>
          </svg>

          <svg
            id="gmail"
            class="absolute top-1/4 right-10 w-[32px] h-[32px] opacity-70 drop-shadow-subtle animate-float-fast delay-[2000ms]"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 32 32"
          >
            <path
              fill="#ea4435"
              d="M16.58,19.1068l-12.69-8.0757A3,3,0,0,1,7.1109,5.97l9.31,5.9243L24.78,6.0428A3,3,0,0,1,28.22,10.9579Z"
            >
            </path>

            <path
              fill="#00ac47"
              d="M25.5,5.5h4a0,0,0,0,1,0,0v18a3,3,0,0,1-3,3h0a3,3,0,0,1-3-3V7.5a2,2,0,0,1,2-2Z"
              transform="rotate(180 26.5 16)"
            >
            </path>

            <path
              fill="#ffba00"
              d="M29.4562,8.0656c-.0088-.06-.0081-.1213-.0206-.1812-.0192-.0918-.0549-.1766-.0823-.2652a2.9312,2.9312,0,0,0-.0958-.2993c-.02-.0475-.0508-.0892-.0735-.1354A2.9838,2.9838,0,0,0,28.9686,6.8c-.04-.0581-.09-.1076-.1342-.1626a3.0282,3.0282,0,0,0-.2455-.2849c-.0665-.0647-.1423-.1188-.2146-.1771a3.02,3.02,0,0,0-.24-.1857c-.0793-.0518-.1661-.0917-.25-.1359-.0884-.0461-.175-.0963-.267-.1331-.0889-.0358-.1837-.0586-.2766-.0859s-.1853-.06-.2807-.0777a3.0543,3.0543,0,0,0-.357-.036c-.0759-.0053-.1511-.0186-.2273-.018a2.9778,2.9778,0,0,0-.4219.0425c-.0563.0084-.113.0077-.1689.0193a33.211,33.211,0,0,0-.5645.178c-.0515.022-.0966.0547-.1465.0795A2.901,2.901,0,0,0,23.5,8.5v5.762l4.72-3.3043a2.8878,2.8878,0,0,0,1.2359-2.8923Z"
            >
            </path>

            <path
              fill="#4285f4"
              d="M5.5,5.5h0a3,3,0,0,1,3,3v18a0,0,0,0,1,0,0h-4a2,2,0,0,1-2-2V8.5a3,3,0,0,1,3-3Z"
            >
            </path>

            <path
              fill="#c52528"
              d="M2.5439,8.0656c.0088-.06.0081-.1213.0206-.1812.0192-.0918.0549-.1766.0823-.2652A2.9312,2.9312,0,0,1,2.7426,7.32c.02-.0475.0508-.0892.0736-.1354A2.9719,2.9719,0,0,1,3.0316,6.8c.04-.0581.09-.1076.1342-.1626a3.0272,3.0272,0,0,1,.2454-.2849c.0665-.0647.1423-.1188.2147-.1771a3.0005,3.0005,0,0,1,.24-.1857c.0793-.0518.1661-.0917.25-.1359A2.9747,2.9747,0,0,1,4.3829,5.72c.089-.0358.1838-.0586.2766-.0859s.1853-.06.2807-.0777a3.0565,3.0565,0,0,1,.357-.036c.076-.0053.1511-.0186.2273-.018a2.9763,2.9763,0,0,1,.4219.0425c.0563.0084.113.0077.169.0193a2.9056,2.9056,0,0,1,.286.0888,2.9157,2.9157,0,0,1,.2785.0892c.0514.022.0965.0547.1465.0795a2.9745,2.9745,0,0,1,.3742.21A2.9943,2.9943,0,0,1,8.5,8.5v5.762L3.78,10.9579A2.8891,2.8891,0,0,1,2.5439,8.0656Z"
            >
            </path>
          </svg>

          <svg
            id="whatsapp"
            class="absolute bottom-20 left-15 w-[38.5px] h-[38.5px] opacity-70 drop-shadow-subtle animate-float-fast delay-[4000ms]"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 38.51 38.5"
          >
            <defs>
              <linearGradient
                id="a"
                x1="5.65"
                x2="32.85"
                y1="5.65"
                y2="32.85"
                gradientUnits="userSpaceOnUse"
              >
                <stop offset="0" stop-color="#7eed91"></stop>

                <stop offset=".61" stop-color="#37cf60"></stop>

                <stop offset=".99" stop-color="#08bb40"></stop>
              </linearGradient>
            </defs>

            <g>
              <g>
                <path
                  fill="url(#a)"
                  d="M38.51,19.25v.03c0,.5-.02,1-.07,1.49-.36,4.69-2.44,8.93-5.59,12.08-3.18,3.18-7.45,5.25-12.19,5.59-.46.04-.94.06-1.41.06-4.1,0-7.9-1.29-11.03-3.49C3.26,31.51,0,25.75,0,19.25c0-5.29,2.17-10.11,5.65-13.6C9.14,2.16,13.95,0,19.25,0s10.11,2.16,13.6,5.65,5.66,8.31,5.66,13.6Z"
                >
                </path>

                <path
                  fill="#2dad40"
                  d="M38.44,20.77c-.36,4.69-2.44,8.93-5.59,12.08-3.18,3.18-7.45,5.25-12.19,5.59l-12.83-7.88s-.25-.27-.21-.47l1.28-6.18c-.83-1.62-1.3-3.45-1.31-5.4-.02-6.39,5.01-11.7,11.4-12.01,3.54-.16,6.76,1.21,9.06,3.51,2.2,2.19,6.99,7.24,10.39,10.76Z"
                >
                </path>

                <g>
                  <path
                    fill="#fff"
                    d="M18.92,6.5c-6.38.3-11.42,5.62-11.4,12.01,0,1.95.48,3.78,1.3,5.41l-1.27,6.18c-.07.33.23.63.56.55l6.05-1.43c1.55.77,3.3,1.22,5.15,1.25,6.52.1,11.96-5.08,12.16-11.6.22-6.99-5.55-12.69-12.56-12.35h0ZM26.14,25.11c-1.77,1.77-4.13,2.75-6.64,2.75-1.47,0-2.87-.33-4.18-.98l-.84-.42-3.71.88.78-3.79-.42-.81c-.68-1.33-1.02-2.76-1.02-4.26,0-2.51.98-4.86,2.75-6.64,1.76-1.76,4.15-2.75,6.64-2.75s4.86.98,6.63,2.75c1.77,1.77,2.75,4.13,2.75,6.63s-.99,4.88-2.75,6.64h0Z"
                  >
                  </path>

                  <path
                    fill="#fcfcfc"
                    d="M25.32,21.07l-2.32-.67c-.3-.09-.63,0-.86.23l-.57.58c-.24.24-.6.32-.92.19-1.1-.44-3.41-2.5-4-3.53-.17-.3-.14-.67.07-.94l.5-.64c.19-.25.24-.59.11-.88l-.98-2.21c-.23-.53-.91-.68-1.35-.31-.65.55-1.42,1.38-1.51,2.3-.16,1.63.53,3.68,3.17,6.14,3.05,2.84,5.49,3.22,7.08,2.83.9-.22,1.62-1.09,2.08-1.81.31-.49.07-1.14-.49-1.3h0Z"
                  >
                  </path>
                </g>
              </g>
            </g>
          </svg>

          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 100 100"
            id="discord"
            class="absolute bottom-12 right-10 w-12 sm:w-16 opacity-70 animate-float-slow"
            style="filter: drop-shadow(0 4px 6px rgba(102, 101, 210, 0.4));"
          >
            <path
              fill="#6665d2"
              d="M85.22,24.958c-11.459-8.575-22.438-8.334-22.438-8.334l-1.122,1.282
      c13.623,4.087,19.954,10.097,19.954,10.097c-19.491-10.731-44.317-10.654-64.59,0c0,0,6.571-6.331,20.996-10.418l-0.801-0.962
      c0,0-10.899-0.24-22.438,8.334c0,0-11.54,20.755-11.54,46.319c0,0,6.732,11.54,24.442,12.101c0,0,2.965-3.526,5.369-6.571
      c-10.177-3.045-14.024-9.376-14.024-9.376c6.394,4.001,12.859,6.505,20.916,8.094c13.108,2.698,29.413-0.076,41.591-8.094
      c0,0-4.007,6.491-14.505,9.456c2.404,2.965,5.289,6.411,5.289,6.411c17.71-0.561,24.441-12.101,24.441-12.02
      C96.759,45.713,85.22,24.958,85.22,24.958z M35.055,63.824c-4.488,0-8.174-3.927-8.174-8.815
      c0.328-11.707,16.102-11.671,16.348,0C43.229,59.897,39.622,63.824,35.055,63.824z M64.304,63.824
      c-4.488,0-8.174-3.927-8.174-8.815c0.36-11.684,15.937-11.689,16.348,0C72.478,59.897,68.872,63.824,64.304,63.824z"
            />
          </svg>
        </div>

        <div class="mx-auto max-w-4xl flex flex-col items-center justify-center">
          <h1 class="text-brand mt-10 flex items-center text-sm font-semibold leading-6">
            Ottr
            <small class="bg-brand/5 text-[0.8125rem] ml-3 rounded-full px-2 font-medium leading-6">
              v{Application.spec(:phoenix, :vsn)}
            </small>
          </h1>

          <p class="text-[3rem] mt-4 font-semibold leading-[3.5rem] tracking-tighter text-[#073127] text-center">
            AI-Powered Workflow
            <span class="relative">
              Orchestration
              <span class="absolute left-0 bottom-0 w-full h-1 bg-gradient-to-r from-green-400 to-[#E2FB6C] rounded">
              </span>
            </span>
            <br /> That Adapts in Real Time
          </p>

          <div class="w-[80%] mt-6">
            <p class="text-base leading-relaxed text-zinc-600 text-center">
              Ottr makes it effortless to execute complex logic, evaluate conditions on the fly ⚡, and seamlessly move through multi-step processes without writing boilerplate code.
            </p>
          </div>

          <div
            class="flex flex-row-reverse gap-4 items-center mt-6 z-20"
            style="display: flex; flex-direction: row-reverse;"
          >
            <.link
              href={~p"/users/register"}
              class="phx-submit-loading:opacity-75 bg-[#073127] hover:bg-[#004838] text-[#E2FB6C] text-sm px-4 py-2 font-light rounded-sm shadow-none transition-colors text-nowrap"
            >
              Start for Free
            </.link>

            <.link
              href={~p"/users/log_in"}
              class="phx-submit-loading:opacity-75 bg-[white] hover:bg-[white]/80 text-[#004838] text-sm px-4 py-2 font-semibold rounded-sm shadow-none transition-colors text-nowrap"
            >
              Continue
            </.link>
          </div>
        </div>
      </section>
      <%!-- partners --%> <.partners />
    </div>
    """
  end
end
