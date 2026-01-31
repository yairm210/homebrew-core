class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.46.2.tar.gz"
  sha256 "7a2c5f0d63ee402bcf0b6399c164db650e8ec705c89561398a32a39323ab3920"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e50f3e2d443af52e1fe9483a1074d1f24907ab0d6870018039116d3b78a68e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e50f3e2d443af52e1fe9483a1074d1f24907ab0d6870018039116d3b78a68e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17e50f3e2d443af52e1fe9483a1074d1f24907ab0d6870018039116d3b78a68e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5312a5febc3125f3f07df992cdacaf39fbdbb29f574547e1beb48776380b2a86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b487b0f338c7bcc9a63d31f5b80a198332f90f3ba25572ae94cd9d0cbdfae2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a99d5ad5134609599e4959c71eeb9c5d2d837cbbb97ba5aae54fc3ba95bab070"
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
