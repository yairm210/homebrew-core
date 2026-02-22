class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "e7ab25e6cce597d9442d02f9abd7241ce1b11b20cc89d1e701537ce7f3229e22"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6a3953f6d9dbde2e804a288ccdd2274a5a73b17801baa3b308cfc457b1bdca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6a3953f6d9dbde2e804a288ccdd2274a5a73b17801baa3b308cfc457b1bdca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6a3953f6d9dbde2e804a288ccdd2274a5a73b17801baa3b308cfc457b1bdca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "81feeb142e96c526de5b1344b857827486af9ddb8185967121ecd0bf2e6ec2f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4428c941d5fadd8c7fa6126f2a0a53210e8d0f3498a05dbd65be57ccf9edfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f643d41c6cc1448caed1277cf2565d36e7b353636a372361f955b4075f953576"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
