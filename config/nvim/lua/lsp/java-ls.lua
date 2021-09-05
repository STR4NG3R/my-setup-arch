local bundles = {
    vim.fn.glob(
        "~/.config/nvim/.debuggers/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
};

local on_attach = function(client, bufr)
    -- require('jdtls').setup_dap()
    require'lsp'.common_on_attach(client, bufr)
end
require'lspconfig'.jdtls.setup{
  on_attach = on_attach,
   cmd = {[[
     JAR="$HOME/.config/nvim/.language-servers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar"
     GRADLE_HOME=$HOME/gradle $HOME/.sdkman/candidates/java/current/bin/java \
     -Declipse.application=org.eclipse.jdt.ls.core.id1 \
     -Dosgi.bundles.defaultStartLevel=4 \
     -Declipse.product=org.eclipse.jdt.ls.core.product \
     -Dlog.protocol=true \
     -Dlog.level=ALL \
     -javaagent:/usr/local/share/lombok/lombok.jar \
     -Xms1g \
     -Xmx2G \
     -jar $(echo "$JAR") \
     -configuration "$HOME/.config/nvim/.language-servers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux" \
     -data "${1:-$HOME/workspace}" \
     --add-modules=ALL-SYSTEM \
     --add-opens java.base/java.util=ALL-UNNAMED \
     --add-opens java.base/java.lang=ALL-UNNAMED
 ]]},
  root_dir = require'lspconfig/util'.root_pattern(".git", "pom.xml"),
  -- root_dir = require('jdtls.setup').find_root({'build.gradle', 'pom.xml', '.git'}),
  init_options = {bundles = bundles}
}
