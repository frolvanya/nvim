local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    opts.max_width = opts.max_width or 90
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require('lspconfig.ui.windows').default_options.border = 'rounded'
