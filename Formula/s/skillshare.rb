class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "b631d891bfcef0989479841ed55464eb2756ce559ed6419ee60e6e6721436b28"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b017fc2ad53a203b116498681f6dd6e375a01e98ede5255898dcbab57496a2dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b017fc2ad53a203b116498681f6dd6e375a01e98ede5255898dcbab57496a2dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b017fc2ad53a203b116498681f6dd6e375a01e98ede5255898dcbab57496a2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8e5f9e281480abb534a67f138aa9f403f6182bf01e4f620f8a980b0acf0ca3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26b30739400c5126eec87413c9c2f4aa6d9887ad499bb0f6f08b148a565cf079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2add5462f82f1df8c1da2ad1d519c8d531b23b6a4e6e44c8c2ba0c3fe3b8deb"
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
