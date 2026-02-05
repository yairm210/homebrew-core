class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.9.1.tgz"
  sha256 "53356c6ecb7cd5d253b828def43c1727d2f60a6f022c81b93ba29646fa20bc7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff2e1f9a5e6b3cc49c38092741ce9d986bd069c3e354feec0861484a4621674d"
    sha256 cellar: :any,                 arm64_sequoia: "9591c6372f9b491828dffddf9130ac6712a6ead825bef28d89c0df4f13f84fe3"
    sha256 cellar: :any,                 arm64_sonoma:  "9591c6372f9b491828dffddf9130ac6712a6ead825bef28d89c0df4f13f84fe3"
    sha256 cellar: :any,                 sonoma:        "a5b08810b2cd89fcef0f2641e11c9c79e786414f61654bf4c34f5cd5db417fcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa6c5ff03b94a4d3defa9f62da5a233a1f7930e6cae3071408deaa7fa427687e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac7f74184e9b30bc523c21a6f34a9f0df7f2a66b545c8187216c607eddb3939"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
