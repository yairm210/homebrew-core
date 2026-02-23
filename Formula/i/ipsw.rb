class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.655.tar.gz"
  sha256 "6ab638127aa7d825db3d41c388a9658039da62122eec5d7efdaa4a3c1d4d9421"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ddf33e2e409b21a32d071c0435a9e21f39de2d8cdb6e4d8af7708b91416665e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e8bb93980ed91aa9ca259874a6dfe1d70c5b68ef13f4eac5803a1684072117d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cb61c38d9fa519cfc0b2ca0ed0eddd8510fbcfe68d4a3eafcec2d5f245b2d47"
    sha256 cellar: :any_skip_relocation, sonoma:        "90500001bea3200f2ec76c576334d5db253a02d72c2194ed13eb7ebaf9840152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c934bbccf3a7ef0df1ea4b942d2378f95731a0a562ec4cc61811ed40b77231cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf5bca36426eeba3a18bb85a1d82b7bf4a333b8feacf3d6f561330f8927a5da"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
