defmodule OttrWeb.Dashboard.Playground.ConfigPanel do
  use Phoenix.Component
  import Phoenix.HTML.Form
  alias Phoenix.LiveView.JS

  attr :node_types, :map, default: %{}
  attr :integrations, :list, default: []

  def config_panel(assigns) do
    ~H"""
    <div
      x-data="{
        open: false,
        nodeId: null,
        nodeType: null,
        nodeData: {},
        activeTab: 'config',
        testResult: null,
        isLoading: false,
        errors: {}
      }"
      x-on:open-node-sheet.window="
        open = true;
        nodeId = $event.detail.nodeId;
        nodeType = $event.detail.nodeType;
        nodeData = $event.detail.nodeData || {};
        activeTab = 'config';
        testResult = null;
        errors = {};
      "
      x-on:keydown.escape.window="open = false; $dispatch('close-node-sheet')"
      x-on:close-node-sheet.window="open = false"
    >
      <div
        x-show="open"
        x-transition:enter="transition-opacity ease-in-out duration-300"
        x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100"
        x-transition:leave="transition-opacity ease-in-out duration-300"
        x-transition:leave-start="opacity-100"
        x-transition:leave-end="opacity-0"
        class="fixed inset-0 bg-black/30 z-40"
        @click="open = false; $dispatch('close-node-sheet')"
      >
      </div>

      <div
        x-show="open"
        x-transition:enter="transition ease-in-out duration-300"
        x-transition:enter-start="translate-x-full"
        x-transition:enter-end="translate-x-0"
        x-transition:leave="transition ease-in-out duration-300"
        x-transition:leave-start="translate-x-0"
        x-transition:leave-end="translate-x-full"
        class="fixed top-0 right-0 h-full w-[500px] bg-white shadow-xl z-50 border-l border-zinc-200 flex flex-col"
        @click.outside="open = false; $dispatch('close-node-sheet')"
      >
        <div class="flex items-center justify-between p-6 border-b border-zinc-200 bg-zinc-50">
          <div class="flex items-center space-x-3">
            <div
              class="w-10 h-10 rounded-lg flex items-center justify-center"
              x-bind:class="nodeType ? getNodeTypeColor(nodeType) : 'bg-gray-100'"
            >
              <template x-if="nodeType">
                <span x-text="getNodeTypeIcon(nodeType)" class="text-lg"></span>
              </template>
            </div>

            <div>
              <h2 class="text-lg font-semibold text-gray-900" x-text="getNodeTypeName(nodeType)">
                Configure Node
              </h2>

              <p class="text-sm text-gray-500" x-text="nodeId"></p>
            </div>
          </div>

          <button
            @click="open = false; $dispatch('close-node-sheet')"
            class="text-gray-400 hover:text-gray-600 p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <Heroicons.x_mark class="w-5 h-5" />
          </button>
        </div>

        <div class="flex border-b border-zinc-200 bg-white px-6">
          <button
            @click="activeTab = 'config'"
            x-bind:class="activeTab === 'config' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
            class="py-3 px-1 border-b-2 font-medium text-sm mr-8 transition-colors"
          >
            Configuration
          </button>

          <button
            @click="activeTab = 'test'"
            x-bind:class="activeTab === 'test' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
            class="py-3 px-1 border-b-2 font-medium text-sm mr-8 transition-colors"
          >
            Test & Debug
          </button>

          <button
            @click="activeTab = 'help'"
            x-bind:class="activeTab === 'help' ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
            class="py-3 px-1 border-b-2 font-medium text-sm transition-colors"
          >
            Help
          </button>
        </div>

        <div class="flex-1 overflow-auto">
          <div x-show="activeTab === 'config'" class="p-6 space-y-6">
            <div x-show="nodeType" class="space-y-6">
              <template x-if="requiresAuth(nodeType)">
                <div class="space-y-4">
                  <div class="flex items-center space-x-2">
                    <Heroicons.key class="w-4 h-4 text-gray-400" />
                    <h3 class="text-sm font-medium text-gray-900">Authentication</h3>
                  </div>

                  <div class="bg-amber-50 border border-amber-200 rounded-lg p-4">
                    <div class="flex items-start space-x-2">
                      <Heroicons.exclamation_triangle class="w-4 h-4 text-amber-600 mt-0.5" />
                      <div class="text-sm">
                        <p class="text-amber-800 font-medium">Authentication Required</p>

                        <p class="text-amber-700 mt-1">
                          Connect your account or provide API credentials.
                        </p>
                      </div>
                    </div>
                  </div>

                  <div class="grid grid-cols-1 gap-4" x-html="renderAuthFields(nodeType)"></div>
                </div>
              </template>

              <div class="space-y-4">
                <div class="flex items-center space-x-2">
                  <Heroicons.cog_6_tooth class="w-4 h-4 text-gray-400" />
                  <h3 class="text-sm font-medium text-gray-900">Configuration</h3>
                </div>

                <div class="space-y-4" x-html="renderConfigFields(nodeType)"></div>
              </div>

              <div x-data="{ showAdvanced: false }" class="space-y-4">
                <button
                  @click="showAdvanced = !showAdvanced"
                  class="flex items-center space-x-2 text-sm text-gray-600 hover:text-gray-900"
                >
                  <Heroicons.chevron_right
                    class="w-4 h-4 transition-transform"
                    x-bind:class="showAdvanced ? 'rotate-90' : ''"
                  /> <span>Advanced Settings</span>
                </button>

                <div x-show="showAdvanced" x-collapse class="space-y-4">
                  <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 space-y-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">
                        Timeout (seconds)
                      </label>

                      <input
                        type="number"
                        x-model="nodeData.timeout"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        placeholder="30"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">
                        Max Retries
                      </label>

                      <input
                        type="number"
                        x-model="nodeData.maxRetries"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        placeholder="3"
                      />
                    </div>

                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">
                        On Error
                      </label>

                      <select
                        x-model="nodeData.onError"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      >
                        <option value="stop">Stop execution</option>

                        <option value="continue">Continue with next node</option>

                        <option value="retry">Retry after delay</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div x-show="!nodeType" class="text-center py-12">
              <Heroicons.cube class="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <h3 class="text-lg font-medium text-gray-900 mb-2">No Node Selected</h3>

              <p class="text-gray-500">Select a node from the workflow to configure it.</p>
            </div>
          </div>

          <div x-show="activeTab === 'test'" class="p-6 space-y-6">
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <h3 class="text-sm font-medium text-gray-900">Test Configuration</h3>

                <button
                  @click="testNode()"
                  x-bind:disabled="isLoading"
                  class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
                >
                  <Heroicons.play class="w-4 h-4" x-show="!isLoading" />
                  <div
                    class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"
                    x-show="isLoading"
                  >
                  </div>
                   <span x-text="isLoading ? 'Testing...' : 'Run Test'"></span>
                </button>
              </div>

              <div x-show="testResult" class="space-y-4">
                <div
                  class="p-4 rounded-lg border"
                  x-bind:class="testResult?.success ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'"
                >
                  <div class="flex items-start space-x-2">
                    <Heroicons.check_circle
                      class="w-5 h-5 text-green-600 mt-0.5"
                      x-show="testResult?.success"
                    />
                    <Heroicons.x_circle
                      class="w-5 h-5 text-red-600 mt-0.5"
                      x-show="!testResult?.success"
                    />
                    <div class="flex-1">
                      <h4
                        class="font-medium"
                        x-bind:class="testResult?.success ? 'text-green-900' : 'text-red-900'"
                        x-text="testResult?.success ? 'Test Passed' : 'Test Failed'"
                      >
                      </h4>

                      <p
                        class="text-sm mt-1"
                        x-bind:class="testResult?.success ? 'text-green-700' : 'text-red-700'"
                        x-text="testResult?.message"
                      >
                      </p>
                    </div>
                  </div>
                </div>

                <div x-show="testResult?.data" class="space-y-2">
                  <h4 class="text-sm font-medium text-gray-900">Response Data</h4>
                   <pre
                    class="bg-gray-100 p-4 rounded-lg text-sm overflow-auto max-h-64"
                    x-text="JSON.stringify(testResult?.data, null, 2)"
                  ></pre>
                </div>
              </div>

              <div class="space-y-4">
                <h4 class="text-sm font-medium text-gray-900">Sample Input Data</h4>

                <div class="bg-gray-50 border border-gray-200 rounded-lg p-4">
                  <textarea
                    x-model="nodeData.sampleData"
                    class="w-full h-32 text-sm font-mono resize-none border-0 bg-transparent focus:ring-0"
                    placeholder='{"example": "data"}'
                  ></textarea>
                </div>
              </div>
            </div>
          </div>

          <div x-show="activeTab === 'help'" class="p-6 space-y-6">
            <div class="space-y-4" x-html="renderHelpContent(nodeType)"></div>
          </div>
        </div>

        <div class="border-t border-zinc-200 p-6 bg-gray-50">
          <div class="flex items-center justify-between">
            <button
              @click="open = false; $dispatch('close-node-sheet')"
              class="px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50"
            >
              Cancel
            </button>

            <div class="flex space-x-3">
              <button
                @click="saveAndTest()"
                class="px-4 py-2 text-blue-700 bg-blue-50 border border-blue-200 rounded-lg hover:bg-blue-100"
              >
                Save & Test
              </button>

              <button
                @click="saveConfiguration()"
                class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      window.getNodeTypeColor = function(nodeType) {
        const colors = {
          'webhook': 'bg-green-100 text-green-600',
          'http': 'bg-blue-100 text-blue-600',
          'email': 'bg-purple-100 text-purple-600',
          'database': 'bg-orange-100 text-orange-600',
          'slack': 'bg-pink-100 text-pink-600',
          'google': 'bg-red-100 text-red-600',
          'filter': 'bg-yellow-100 text-yellow-600',
          'transform': 'bg-indigo-100 text-indigo-600'
        };
        return colors[nodeType] || 'bg-gray-100 text-gray-600';
      };

      window.getNodeTypeIcon = function(nodeType) {
        const icons = {
          'webhook': '🔗',
          'http': '🌐',
          'email': '📧',
          'database': '🗄️',
          'slack': '💬',
          'google': '🔍',
          'filter': '🔍',
          'transform': '⚡'
        };
        return icons[nodeType] || '⚙️';
      };

      window.getNodeTypeName = function(nodeType) {
        const names = {
          'webhook': 'Webhook Trigger',
          'http': 'HTTP Request',
          'email': 'Email Service',
          'database': 'Database Query',
          'slack': 'Slack Integration',
          'google': 'Google Services',
          'filter': 'Data Filter',
          'transform': 'Data Transform'
        };
        return names[nodeType] || 'Unknown Node';
      };

      window.requiresAuth = function(nodeType) {
        const authRequired = ['slack', 'google', 'email', 'database', 'github'];
        return authRequired.includes(nodeType);
      };

      window.renderAuthFields = function(nodeType) {
        // This would be replaced with actual server-side rendering
        // or a more sophisticated client-side template system
        return `
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">API Key</label>
              <input type="password" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="Enter your API key">
            </div>
          </div>
        `;
      };

      window.renderConfigFields = function(nodeType) {
        // Dynamic field rendering based on node type
        const fieldTemplates = {
          'http': `
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">URL</label>
              <input type="url" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="https://api.example.com/endpoint">
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Method</label>
              <select class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option>GET</option>
                <option>POST</option>
                <option>PUT</option>
                <option>DELETE</option>
              </select>
            </div>
          `,
          'email': `
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">To</label>
              <input type="email" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="recipient@example.com">
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Subject</label>
              <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder="Email subject">
            </div>
          `
        };

        return fieldTemplates[nodeType] || '<p class="text-gray-500">No configuration options available.</p>';
      };

      window.renderHelpContent = function(nodeType) {
        return `
          <div class="space-y-4">
            <h3 class="text-lg font-semibold text-gray-900">How to use ${window.getNodeTypeName(nodeType)}</h3>
            <p class="text-gray-600">Documentation and examples for this integration will appear here.</p>
          </div>
        `;
      };
    </script>
    """
  end
end
