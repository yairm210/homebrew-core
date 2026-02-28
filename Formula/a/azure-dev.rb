class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.7.tar.gz"
  sha256 "7ff8848120861b702377172f63961f3d89f615b3d72b867d60dabd6b4ffdd536"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89af11734e9f3f9450921aa48a98d9c3062235501e291f749d7cf07cd5c176c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89af11734e9f3f9450921aa48a98d9c3062235501e291f749d7cf07cd5c176c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89af11734e9f3f9450921aa48a98d9c3062235501e291f749d7cf07cd5c176c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4a7c722acdfb3353157f5c415499312e7772cd212d28916d0b9306fac8483d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b1cc1ea2c53fed5ce5226b59c574de1000e5604a4984c78f98732f0d7cd684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4ababede286df87b5d09a6a103aa810cfac89056ccee25a843fc55da7c88adf"
  end

  depends_on "go" => :build

  def install
    (buildpath/".installed-by.txt").write "brew"

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = "#{version} (commit 0000000000000000000000000000000000000000)"
    ldflags = %W[
      -s -w
      -X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"
    ]
    system "go", "build", "-C", "cli/azd", *std_go_args(ldflags:, output: bin/"azd")

    generate_completions_from_executable(bin/"azd", shell_parameter_format: :cobra)
  end

  test do
    ENV["AZURE_DEV_COLLECT_TELEMETRY"] = "no"
    ENV["AZD_DISABLE_PROMPTS"] = "1"
    ENV["AZD_CONFIG_DIR"] = (testpath/"config").to_s

    assert_match version.to_s, shell_output("#{bin}/azd version")

    system bin/"azd", "config", "set", "defaults.location", "eastus"
    assert_match "eastus", shell_output("#{bin}/azd config get defaults.location")

    expected = "Not logged in, run `azd auth login` to login to Azure"
    assert_match expected, shell_output("#{bin}/azd auth login --check-status")
  end
end
