class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "77ff0e0a227113dbae19641f72b0bb0eced5b5cb5a7e8365db8d9a905e88f179"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0475a8bd99f4515242ff5dcb188b2a0934cc04e13bc611d64fb067b87a98cbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0475a8bd99f4515242ff5dcb188b2a0934cc04e13bc611d64fb067b87a98cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0475a8bd99f4515242ff5dcb188b2a0934cc04e13bc611d64fb067b87a98cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "daa49b7f6bc97fe44fc6731c71ae7b6689e3539d36dc56ef90ce49a969a5c35f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f54daddd8d771f2b7b96efe44b118628127727083cbe27931b80a678f443ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe71fdc9ed79848bf6ffb77cfeb0e148e7926ab03190d4309c103ccfd355a24"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
