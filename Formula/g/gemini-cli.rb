class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.5.tgz"
  sha256 "baaac2889ece5514632537c99aa7cda558a6b469ad771e204f56db2b8cf6402a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f5b59951bb88cd3000b19449dec28cbe71a36e1542140758cdd9e3b4b5e1256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5b59951bb88cd3000b19449dec28cbe71a36e1542140758cdd9e3b4b5e1256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f5b59951bb88cd3000b19449dec28cbe71a36e1542140758cdd9e3b4b5e1256"
    sha256 cellar: :any_skip_relocation, sonoma:        "c59abd72fc986ed3ad0fe93da39f624fd477d5e5fa0d073f06fcada2cfbd0756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7d8f3e2ae0c56dcf36b826f758e015d34377faaeb0f0361ffc1f65dd5184736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80d6d861f32ab6bbb31bd18f35c86f1cc12ef544cc81585b06978e30f18c0fd"
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
