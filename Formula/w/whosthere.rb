class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "fafb6a69cf64593818c2944055b7a55572715f6136aa0b97767843b68c3556f7"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a67755e7b6b2d7d0a43e2f3bb3e6abeed9e6d3c555d2484d21ca0ba3015ab014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90fc9589d7e70dc3dc529a9597d3e33101db7ae57abad6416fd43ff1f69e5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fce4c776f6ee7d3ab109429bea0f0f34b07f4218c4bf261eb80161c84de90ca1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3632e83b7ac53fd1da174b183668e2e6810badf391b61fcbd90469adbc01f964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ec8df058d8df7b0cb85446cbd8e52aa5280f6b73e3d7d11fd2810b2b6246a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936a68600a03812db3dda707b62527a361a32713440c59c4c60253d2d89eb679"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionStr=#{version}
      -X main.dateStr=#{Time.now.utc.iso8601}
    ]

    ldflags << "-X main.commitStr=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whosthere --version")
    output = shell_output("#{bin}/whosthere --interface non_existing 2>&1", 1)
    assert_match "network_interface does not exist", output
  end
end
