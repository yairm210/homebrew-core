class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "7d21e08ac626057531289bd61004503ff17a527d5c1f210f92550fe13ba64770"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b2a61c56ec3eedb071899315d28889e3be3da99778cd3147e1e85e90155e747"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2a61c56ec3eedb071899315d28889e3be3da99778cd3147e1e85e90155e747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b2a61c56ec3eedb071899315d28889e3be3da99778cd3147e1e85e90155e747"
    sha256 cellar: :any_skip_relocation, sonoma:        "069f92b24616b439e5b9055bb928295c6a5c8ca3735ff0aabf310e4189b252a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3694c837c8dbef5ea7ead14f64480fa66bcb819a0b9548cc1a501aef2e8e8412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1506b9affbdb97ca4c1c4818731d97e1246cb0b042673ad48c6f6e481514f2c"
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
