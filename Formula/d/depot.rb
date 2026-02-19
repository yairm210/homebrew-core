class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.8.tar.gz"
  sha256 "cb94fa7a620573131a90fef4822711d95faa7f6dd50ef41f31c84c20b33b7e6e"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f046307f2a6caab4f180e3921660fa3e5456ebace78623f969244be7fbd076f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f046307f2a6caab4f180e3921660fa3e5456ebace78623f969244be7fbd076f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f046307f2a6caab4f180e3921660fa3e5456ebace78623f969244be7fbd076f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac4a68ae8f7d355ccb437bf1ae97ef9f86bfdcc8cf6c1db5eab163f3f51fe91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d284a9629c2eafb1e111aa8d975a66e3e88f085f95d854e234be35e6705c78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "addf8b1a8d70605c61b0dd7ce3dd0c9809f11cceccccf81c40776744a9438fc0"
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
