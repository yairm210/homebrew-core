class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "a34cad12ae1dd4e6f44e14dc649343bb36fc0a76cf5e903905161e402333c012"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50be2a76b7c95727c1f030f02620480166072ce9d9fe06a950078e860d925d5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50be2a76b7c95727c1f030f02620480166072ce9d9fe06a950078e860d925d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50be2a76b7c95727c1f030f02620480166072ce9d9fe06a950078e860d925d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e07ba13718c48568f2070651b09dda4a85bc4b4331ad8d9b4e187f1fc9532640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0c4a631e4be6b4bcf89ffa1102363b08c81d5074e40658fe311955903d220fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22457d27c5be6b12fcb3672428507b199ead602393161b2f58c32c89a05d2e32"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
