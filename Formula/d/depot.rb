class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.13.tar.gz"
  sha256 "ec8ba3f1408f14c15b0b556b7fceb2c922d6dfffe5b7e5ba540e922839e6d97e"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94f9feaa456712c996f0b8fca68fa12572dfd8ac63bf6f5ff3722dea051cdd45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94f9feaa456712c996f0b8fca68fa12572dfd8ac63bf6f5ff3722dea051cdd45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f9feaa456712c996f0b8fca68fa12572dfd8ac63bf6f5ff3722dea051cdd45"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf128dd02b6738ac1dec8c39bfa0444844b4ab7d155637c24e19adc7502704b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4727ff87b6857ff291f81926c9074cf66006cc85c35a9e5c0b3a311964a0ed42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e23b0d25f9aa1c4ed3eba71d719f475da8e4b76c623e3da0bb8755b5fd821b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
