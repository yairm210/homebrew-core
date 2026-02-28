class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.4.tar.gz"
  sha256 "9fbc140eaf5dcc2c49983e38779cf6c53291c5d550e2565c723cc0688810f078"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd67bc006b6c16ea367e8a25f2a4680c2f4f449aa2ab524cdd0c1665f80f9218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd67bc006b6c16ea367e8a25f2a4680c2f4f449aa2ab524cdd0c1665f80f9218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd67bc006b6c16ea367e8a25f2a4680c2f4f449aa2ab524cdd0c1665f80f9218"
    sha256 cellar: :any_skip_relocation, sonoma:        "06d5f9cc815b63019027c442251241dc00ef16f60ad6f33f42581ea61f2901ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da58756a0523c4f3f5b6dfc7319a0e5a20b7df19ba4f448c58caf11b047859b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f21e50ced2e78cfdb069c68ab4cff1e4f101656226dc61f8ba35d6d4efc3be4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
