class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.203",
      revision: "beed02761e68b6b5b121d0565f325c0cc7b8a415"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cba4ff6323db88f9e8aa34c81d3baee6f2c5a0c86b3f85d5e6a7d7673ab6ccda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7851d497c85c9bdcf6ce49909bff2de5eb90ece37b55f86ecb3cf3123d98b00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9cc8c756b17dd36ca98b2311e97d9a2c362b7a91d4b0ddd9f2dc5dc3877f88"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5dabec835d99273497afbdd96e1117defc8e57f2b6b0a70bab9880f29d1de2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccee8a9fbfb3765dffcd6729bb14dbd62c21bd3b95e6ba32811acac89ea33979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7924597891c5446b65ea6c892cbc813d112048cefac6574544b824e39d872d8e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
