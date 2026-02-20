class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "740d018007e7da96787c057261e5a239513754102d1ad34d196e028221de0797"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0460b92a2254a712e602c935f177a6dbd6d0539c2abc03a66bf0248aed38f15e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0460b92a2254a712e602c935f177a6dbd6d0539c2abc03a66bf0248aed38f15e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0460b92a2254a712e602c935f177a6dbd6d0539c2abc03a66bf0248aed38f15e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc76974da1e8a6f9790f9d4a24beba65d3e08e85f2e88b10b5658410ab269eeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bac31fd0ebdcc59dc2c00d86eb7ec25b8f294b65a0fbe05443dd5504ff59326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae408e7189dc73f6a856d0dd20724d2a47a85065cfe632798018921ca569ff22"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
