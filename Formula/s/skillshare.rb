class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "7d21e08ac626057531289bd61004503ff17a527d5c1f210f92550fe13ba64770"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "172f8d87f57e2eb626928733d51e834a7cce4815e23dc7c09e1561488cc2e1d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172f8d87f57e2eb626928733d51e834a7cce4815e23dc7c09e1561488cc2e1d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172f8d87f57e2eb626928733d51e834a7cce4815e23dc7c09e1561488cc2e1d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "507b526b2c5502c57b09e86c6149c0a1b965d8ad534e473eceeec4667849e415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4be6070ae2313b3211a0b361a17b3e898fa983e9f3076e79cbd53e5ad2fd6e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d14f4ee440afee2a934659626aa1bd6ded1b27a2355948bf2cf7f26e8da544"
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
