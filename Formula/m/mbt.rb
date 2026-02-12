class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.43.tar.gz"
  sha256 "b93baa727ed23f06f5e36f10e3f7dffc0a6950dd9238921163dac80a4d91d94a"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f997ad2d500ac0250aad8215f714d2ffde0d7c2c6132760498ce034e724d7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f997ad2d500ac0250aad8215f714d2ffde0d7c2c6132760498ce034e724d7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f997ad2d500ac0250aad8215f714d2ffde0d7c2c6132760498ce034e724d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "496fd538562837f1d8d751a53770f9ee27d990633b53eecf9fb4c94897f1ac12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9d17bab82cfba2920244b822c14c227a7e1911bea60c0dfdb05fffd06360f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5a1ae103f77ba25969984de42a43a195be11d3ccd64de5b6baf94118533706"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(/generating the "Makefile_\d+.mta" file/, shell_output("#{bin}/mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}/mbt --version"))
  end
end
