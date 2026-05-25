-- 1. Obtenemos las utilidades de NvChad (esto sigue siendo útil para mantener la UI)
local nvlsp = require "nvchad.configs.lspconfig"
local capabilities = nvlsp.capabilities
local on_attach = nvlsp.on_attach

-- 2. Servidores con configuración estándar
local servers = { "html", "cssls", "jsonls", "bashls", "pylsp", "texlab", "clangd", "rust_analyzer" }

for _, lsp in ipairs(servers) do
  -- En la nueva API, se busca configurar mediante el nombre del servidor
  -- pero por ahora, para mantener compatibilidad con NvChad, lo ideal es:
  vim.api.nvim_create_autocmd("FileType", {
    pattern = lsp, -- O el tipo de archivo correspondiente
    callback = function(args)
      vim.lsp.start({
        name = lsp,
        cmd = { lsp }, -- Esto asume que el binario se llama igual que el lsp
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  })
end

--- 3. Configuración específica para nixd (Migración manual)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    vim.lsp.start({
      name = "nixd",
      cmd = { "nixd" },
      settings = {
        nixd = {
          nixpkgs = { expr = "import <nixpkgs> { }" },
          formatting = { command = { "nixfmt" } },
          options = {
            nixos = {
              expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.NeoReaper.options',
            },
            home_manager = {
              expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.NeoReaper.config.home-manager.users.xardec',
            },
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
})
