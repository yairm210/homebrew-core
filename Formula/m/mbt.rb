class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https://sap.github.io/cloud-mta-build-tool"
  url "https://github.com/SAP/cloud-mta-build-tool/archive/refs/tags/v1.2.37.tar.gz"
  sha256 "9594b4f1bb210f5f5d7eac56b1b489dfe7727d68e70956f12389637f20ce3fd0"
  license "Apache-2.0"
  head "https://github.com/SAP/cloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21397e6773d6670013f378d0bec9a989beb24f18bbc533f3681a42c14c1214ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21397e6773d6670013f378d0bec9a989beb24f18bbc533f3681a42c14c1214ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21397e6773d6670013f378d0bec9a989beb24f18bbc533f3681a42c14c1214ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "370ab219a56cf5e82346ca446b4771606bc727ecfe69666ccb9ab02193c8fecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89c0f8bb3b63dc7203ae3082e6c2226bd6cc2d7d44512374a16cb1d846d2717a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dbb7cdb0a6ccf6022eb15447b17e174130c97e75218ee101622ab4530744cf6"
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
