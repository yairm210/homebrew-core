class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "f0236fdc4897b543b9f3c8d4aac621768bcf827a455cc6a14c6868da842818c4"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fedf191fa1f9caa20b82a27fac494ae0ec31c30cc92167380f8ca3e3eb08cdf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fedf191fa1f9caa20b82a27fac494ae0ec31c30cc92167380f8ca3e3eb08cdf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fedf191fa1f9caa20b82a27fac494ae0ec31c30cc92167380f8ca3e3eb08cdf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "91ce02f4532d42760623fa52f30accd7c2c76709594b3bc648fb1e6a9cb5297b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d675b39b48e33dc2ba308adf78973d3b7c8769d0c41de6920d9a412d5027369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e853301505bd0eab32759ba51a1bf1fd60521cdca491a369e80bd8a44e7d7e5"
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
