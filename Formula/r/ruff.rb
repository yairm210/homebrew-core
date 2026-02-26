class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.3.tar.gz"
  sha256 "a2c2317aeb117a580ce1ef363b408e25251c90911fea77fbb544a54334013c29"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3809cef2ca915f6de6371daa4066f4fff7c0f8537a0ef7c499147f15cfd65369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806d19a0a8f80cbeabf68c42ea6880cb6fa5ab5bc57e814ace99e4504c9bdfcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1e041bda5faeb93288b9a4ada9fee087ed14bc963447d83970f5122b7122c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2893699d8f4f5990477e36af14770a5419a231c6dc82932488409b87e55803aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28fbaef3670535a9e2f5887c52fb2fa37c586546544947961318d33b5e140c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e2d736702fc502d7fa00fd70656c83196db2a4ed483c6b2f35fa43e8e5b1924"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
