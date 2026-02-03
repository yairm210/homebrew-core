class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.29.5.tar.gz"
  sha256 "88d9e476e0178b75f2d95ca483a8a98886593bb54f71dfce7404460669797c6c"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b022dfe407aeb64689cacb9634f789f3470178c2934f0d660acf721027777e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4142b217e61025d543abfeae7fb82c2458566c6ce4b06867a056a3e107d37368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc683dc3a95a70c1c93ff0a0c6cf65dedc3a1b310aa527dc979ec6a3c9d83487"
    sha256 cellar: :any_skip_relocation, sonoma:        "f161170fc6701999111e4359ec74a485da718cec9ac9f43a9c75d13a0e1a60ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a6944bc75a8aab44f660cf809942626b407ea53b17fae6e4323f9ee3fe57e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f41a417642a96e60e782930fa8d2af29d755cc54c52155a388cb8cae6693916"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
