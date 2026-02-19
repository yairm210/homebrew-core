class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.29.4.tgz"
  sha256 "912e7a1379aec8b1bdf1f3499052c2cd3ddade1d5dec22941546aa23c025b2af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43600974f7a5b621b68a793c2f01cb0c5e839346055f9e02ee5953207a2ac047"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43600974f7a5b621b68a793c2f01cb0c5e839346055f9e02ee5953207a2ac047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43600974f7a5b621b68a793c2f01cb0c5e839346055f9e02ee5953207a2ac047"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b8d489965d065984c09723a6abb6e91e5ba0056b3cae3a307e1cc8e12fea41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1784813fab591bc176c847d0dda8fa6daaf7aed187449e1fab43a37be9d0bba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f620120b36fe2b258916f9fd52bb5c11a8ce546d3f259a13186a93a982ff985"
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
