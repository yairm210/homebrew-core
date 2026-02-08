class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "2309e15c2f83ab8bd67a9f268fc36feec633aec1bad7ecf2888be26d7f233b7b"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7faf00b1e70ffa23dcb7d61d33c18568aa73f1230d9275382a6ece610f024501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087ed4941de0968e8f5582c64569ecfca4df1185f64696551376582e652d4e6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c025be4dcf4912dea3ea711082508549d431a7c4082189f571542462620d9fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "664a67391f4125dc962cc9d07984b2acb622bc8e62bd09f182ae2964e45e8880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcf0798783a2a8e127913a7839b203bfc8c7a9a5b9625aeac1eb9992b0a55836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad2a2b9f75ffb6c78723fcb0331d5ce36ed1441efc54e7b35dbf686fd6eadbd7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
