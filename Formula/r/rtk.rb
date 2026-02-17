class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "6a6bc346061f29d117df76e8b619d20739ebeede5b7b7f6003f276e21faf5fdd"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "000dd6140ca9ec659d33faf02c56675acc88de97aa0e0601e9571dc9e26900e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9fc01809622d78dcd624a4ac0934b78ac867342565d655f8d044c887776e305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f6c25960fa8fcb8bcdbbad90deae9bea43b37a4a99aef4dde5fa90a7fdefb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ac60ea1b8c31441bf57a77268fdcc905ce1a467e250535d961d10ca17c8f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bbc6df10a93e854be92a2a0212699f897a438ce2efa5b63fa7f537ac9cfa86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0eb003ec7b2a71b5d8a8e5c2def19347217eb5be908cf8719b3e12fb87ed141"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
