class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.7.tgz"
  sha256 "564b962f582d34b04cb1c5217061126fc548be8d3d40e1ca083c23302e56061d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "197b345ba9f8f342dbb360ab75cd76fe6db5d3a08a042f517bb198c3d11984a2"
    sha256 cellar: :any,                 arm64_sequoia: "93edcd656f8f35e73112f386f7ea5f525be6a90b138130201b745ad9c9735f6c"
    sha256 cellar: :any,                 arm64_sonoma:  "93edcd656f8f35e73112f386f7ea5f525be6a90b138130201b745ad9c9735f6c"
    sha256 cellar: :any,                 sonoma:        "c7305c73a7e77443d716cecf1b8fdaf888b78fe43529f8bd64322604643abd85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba4bfbe477585b59829e5c3ce821bc9caa24bf226bfd6b6876756cfc338600b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15c3775a3d56e758fd2119532e06501b47b98c2fc99b38db875f24b01a28e37d"
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
