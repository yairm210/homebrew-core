class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.99.2.tar.gz"
  sha256 "d0e3a9b4ac0b14b4e3c83a7e14e348786ca00959754811d8325a166f9c06a9be"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba620b3a6ead11a0db0196b2af3ca3779fd34e3c863b92396235aac8eaa0324b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba620b3a6ead11a0db0196b2af3ca3779fd34e3c863b92396235aac8eaa0324b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba620b3a6ead11a0db0196b2af3ca3779fd34e3c863b92396235aac8eaa0324b"
    sha256 cellar: :any_skip_relocation, sonoma:        "50128f5b76e2cace26fb5443840e81ea64ad129d95d7ad21d0329e849d07a9fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65bdaa47c2af1e805279781804ce55fa89e5012f3ba3b90cc5f8b1cd93159e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "712910658d674093d96ccf02b2ecef02f9650b03eeb5976f4b6e648173673cef"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
