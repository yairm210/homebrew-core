class StaticWebAppsCli < Formula
  desc "SWA CLI serves as a local development tool for Azure Static Web Apps"
  homepage "https://azure.github.io/static-web-apps-cli/"
  url "https://registry.npmjs.org/@azure/static-web-apps-cli/-/static-web-apps-cli-2.0.8.tgz"
  sha256 "35b16aae6057ab0a15a083285259b439552c7c1565d0879bf915dc3c0b5282e9"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swa --version")

    system bin/"swa", "init", "--yes"
    assert_path_exists testpath/"swa-cli.config.json"

    token = shell_output("#{bin}/swa deploy --print-token -dr")
    assert_match "undefined", token
    assert_match "Deploying to environment: preview", token
    assert_match testpath.to_s, token
  end
end
