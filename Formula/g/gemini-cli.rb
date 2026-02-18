class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.1.tgz"
  sha256 "6ea743a2c414c4b3ac17975698a88bd07a7de6b21d760d8d653f5c2a0926dcb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20820405baa3462135588f30b30807114e88d6f419060273f9b0fa4ac75ccb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20820405baa3462135588f30b30807114e88d6f419060273f9b0fa4ac75ccb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20820405baa3462135588f30b30807114e88d6f419060273f9b0fa4ac75ccb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1ea4ccc3b463a72c5b602a009df9a2fbe259a8db19ccc34bd4a7fa4a301e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3082a965e5bc426d0124960159b1a803ba04de0a68ea65ae59146f00b55b249a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7c9fb18a96c73148a4ff28462e9e835f327c3885ed1d98eb5648c5911c4107"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*")
      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"node-pty/prebuilds").glob("*")
      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@google/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
