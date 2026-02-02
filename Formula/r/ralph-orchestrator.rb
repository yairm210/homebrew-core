class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "52954182580ee33a009dfd3d9b4ebb6a640426aafc97cc993fba9bf3bd9377aa"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4208f31e9c48bf9f4dae82d61652e0001dba1ce932f33af54430e55c1de21e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a601e61d065544931852c7ede7efc3ece72dff7f656c4b52d17112f5aaadfba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aeb83e0b64c3f48dee9bafad4044288fa15514d05e02dd5adc67ec393dc1a16"
    sha256 cellar: :any_skip_relocation, sonoma:        "cca158a6f848ba66c96e1e73537c713a098993b52107c32ad7f8a06a3ceec88b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae11f7ec68b2fc13e189d5f00c017fd079c82bd8fed52b558eaaee93def61a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f907bdd6a17f844cb6609e45c1e4d51f0fc84cd29e18c54e9ccffaf02b691d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end
