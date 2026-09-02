class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.19.tgz"
  sha256 "0a6fca06371fa7e69be33f6730f78d7bdd69d037390045c4050e961e8b1dfeee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99f69f0be29a043f05338b6e5da2b1fb94c49b83f12781a7af0f44e1a6db8ca8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99f69f0be29a043f05338b6e5da2b1fb94c49b83f12781a7af0f44e1a6db8ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f69f0be29a043f05338b6e5da2b1fb94c49b83f12781a7af0f44e1a6db8ca8"
    sha256 cellar: :any_skip_relocation, sonoma:        "461c2fc73bd39557b263ef73e03ddce76639295656eaa19ead957124daf4b0bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b17758e4add247ab7b9796d0796d5fa03429dfe11bf3d59144f77646ddce18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b17758e4add247ab7b9796d0796d5fa03429dfe11bf3d59144f77646ddce18d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end
