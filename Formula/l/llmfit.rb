class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "6b43201656c6f0cff0892d25e13754d9a5e37272f74be8d6b04e3531dcca7669"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e4f45f5af8ad9565315d19d9aed3bcb5a7690e25f1f74774bd69b483c27559f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef8ee5ac2d6a2f23419ae7a377991745a988bd344f120772d6d4a2a60ec62800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dbcfe0c53e4eccbe8f690b6518b755bac8ebd27c47f4752f0664e335fb74851"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ab9515927ab4d546abc7202032db8313782729ff24af2ba34c0b60660cac531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4a2680616634b56eab5592a18b7c677cb417dc3fa883139635a2bfc1e35c049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1edccf69e576408fca2e018e02962b3805189be861ac55520aa3279b73908128"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
