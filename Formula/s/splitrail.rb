class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "2cb66d8555dc6353456ab97413c366d5c1a82dce36e847754de264f361e406d0"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "755557dded30e50736c8c8b248f449f4b8ba88f380743fafe3ed622e8632904b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a45c70f33fba412918401f2161a6a09a13aada14ff0e2d936cc39f196923e4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6230363a59ed9171310b0ea47d6208994801a66b96e1ef9dd6483edb9fee27e5"
    sha256 cellar: :any,                 arm64_linux:   "b18786b1ad5d24935d8ba57ad3ea91db6916c5bb26e3396526552f772c6cb1eb"
    sha256 cellar: :any,                 x86_64_linux:  "cea482d34a9cbbed11fc831991fa92e0cfc0626d36864f8952687f66ad21e8c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
