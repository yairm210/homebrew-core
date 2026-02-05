class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.27.1.tgz"
  sha256 "21a0e48f7cd051d1ca5546a65a1811623830887bea244c62445254bfafeb6053"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "431a0dc8831aff5663a69ce4f31574d2060b7c0bdfc60bd7b7328be876c404e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "431a0dc8831aff5663a69ce4f31574d2060b7c0bdfc60bd7b7328be876c404e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "431a0dc8831aff5663a69ce4f31574d2060b7c0bdfc60bd7b7328be876c404e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c704ad5e9e0dca6d2570a591546669087b109a465c64def468d70bee27bae760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "684f9a56e599a4ad9cfa70cbd0184b218018d0e5f65b7525634177d31d674fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301e3eabfc086f755076bd5079366681960bd334843b873bc1f60458610ac9e6"
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
