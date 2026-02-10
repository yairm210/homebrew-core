class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.28.0.tgz"
  sha256 "64697ec1d0db1fc500dec29b563efeffeb762fe0a6a742109da45b144a3f61d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe9d3c0f51e59ccdbf62a40eca020c19a265b05ecb9b0da2a52b6a5187dc79bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9d3c0f51e59ccdbf62a40eca020c19a265b05ecb9b0da2a52b6a5187dc79bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe9d3c0f51e59ccdbf62a40eca020c19a265b05ecb9b0da2a52b6a5187dc79bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14fe133e50cc8a98cb9be0c2f922455df3d5fa74a1855ab9fd20483aabd265f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c270900896b7fb76a881c3686b4fd837fc615f13b39c77bfc3f8a65c292e798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc15ab262c797a85eb66ee8626008aa81d074588b9f16f6dc1e8662e3aba42e"
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
