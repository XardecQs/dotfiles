-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "jsonls", "bashls", "pylsp", "texlab", "clangd", "matlab_ls", "rust_analyzer", "arduino_language_server" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

local nvim_lsp = require("lspconfig")
nvim_lsp.nixd.setup({
   cmd = { "nixd" },
   settings = {
      nixd = {
         nixpkgs = {
            expr = "import <nixpkgs> { }",
         },
         formatting = {
            command = { "nixfmt" },
         },
         options = {
            nixos = {
               expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
            },
            home_manager = {
               expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
            },
         },
      },
   },
})

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
