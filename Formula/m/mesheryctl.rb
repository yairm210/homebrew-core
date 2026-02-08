class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.204",
      revision: "224a15f491fcfd5c722c0aff5b001f405f6d7ae0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882485241c445b9852c08fce478386708239344cc56974cfcfb2cba0cd107aaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d822e12c045fe987c2ced5bf49a13e299db32f4ae150de79dc5a64153582df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "304934d0657eb555e14ab5c02cbc593ce7f7bf1a0a8618525fc21c7e1bc72b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2e178542bf73a07a2510236a53aa134ff60cde941afc0fac88c9797edf9309f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bd12fe5a6d58e13b1e529b6cbdf967957664182020ccae07df7491b2e30a57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f1e6724da5bb854c7648c9f545253a9e385c07fdde022d3339fbf2b67120d8"
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
