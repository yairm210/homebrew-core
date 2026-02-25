class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.12.tgz"
  sha256 "c23671c8ca87f0cab79e7a8d380e29694c37868266b773078bd72a72353bbc19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04398d36808989dcbcb98ff3d508e33671130938eceae04b55165f775b3ddd62"
    sha256 cellar: :any,                 arm64_sequoia: "e496ee892d7a604ca70cd5c15f0e6948f87af522f6754fa5f42038391f3f57a5"
    sha256 cellar: :any,                 arm64_sonoma:  "e496ee892d7a604ca70cd5c15f0e6948f87af522f6754fa5f42038391f3f57a5"
    sha256 cellar: :any,                 sonoma:        "c8f6e9dcca016bd10897f72b26c5b7f25e0824c7d052fe0a08e3103c69e54b27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ace51a68b607226859ebe4675a2bd089c0c2ce3fee9f032ec8f32abeed61dd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcdada7019f7eb52523e3cb3c57210bbb2d56e5feb286bddfe02925629ff294f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
