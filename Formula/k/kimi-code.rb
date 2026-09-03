class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.40.0.tgz"
  sha256 "e947fa378eb3f36b306ab1ebc39f74af5aadacba49e8968a5b98ec47f0cc2e83"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61115c9cacda1fbf350dffe6d452486b035ced6f901b8eca4a13193a450fe320"
    sha256 cellar: :any,                 arm64_sequoia: "61115c9cacda1fbf350dffe6d452486b035ced6f901b8eca4a13193a450fe320"
    sha256 cellar: :any,                 arm64_sonoma:  "61115c9cacda1fbf350dffe6d452486b035ced6f901b8eca4a13193a450fe320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf45f0fe497c1204883b254c82ac757c1a7e6f506f35ae4b2986e71724fd6893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9bd24a9589b78a2fed368af2fffa679e68f1a28c1d3947dc7df838be733f560"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    if OS.mac?
      kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
      node_modules = kimi_code_prefix/"node_modules"

      # Remove non-native architecture binaries from `node-pty` and `native`
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
      rm_r kimi_code_prefix/"native/darwin/prebuilds/darwin-#{other_arch}"

      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
