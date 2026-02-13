class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.9.4.tgz"
  sha256 "9c23e680fa9e5e0c979d2e1e9c78262d364ad5d3378eceba4a462b53bbe5b690"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80e673d6ef99c299869dab2375824f9aefab99ebfa1ddb070b4f8aff5a241486"
    sha256 cellar: :any,                 arm64_sequoia: "b683a26a4b91b1233bf0205eefd4fc9c339e5f8ca0dff47c161867dc8d0942bd"
    sha256 cellar: :any,                 arm64_sonoma:  "b683a26a4b91b1233bf0205eefd4fc9c339e5f8ca0dff47c161867dc8d0942bd"
    sha256 cellar: :any,                 sonoma:        "3315d3d98e7c7b10aba033800ac87a7fd51af74f79b7e1f20de73e90c8019657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69b4c762d6dd89253466480a3f17d7ca8cd209876f04110921c56ed8fd4d35ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061419bcfbb731dd13e0734bc4cbba5ee5561fa00fc66aee4529f6ba99fecdab"
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
