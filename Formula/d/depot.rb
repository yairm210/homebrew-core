class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.4.tar.gz"
  sha256 "8b73d64c60687dd85565ab693793dd35e078fa5b661768f5c629bd85e2f637f5"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13adda009fdda0f455bd9cc7aecf1f844aa17d12f71701fb0424255799f91d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13adda009fdda0f455bd9cc7aecf1f844aa17d12f71701fb0424255799f91d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13adda009fdda0f455bd9cc7aecf1f844aa17d12f71701fb0424255799f91d93"
    sha256 cellar: :any_skip_relocation, sonoma:        "28c04403d774b8958065810bfc487dc90d84337d492a42fc25b1fbcb2edcdd72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8d1577c5f7522e58c5a7d8117f1b2542db0bbc4117b090efefb61cd5d4e7bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b22375a37c871e8540d9503a0ad97d789077368a24dd4d9bdb0e5ec32d960f"
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
