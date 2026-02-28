class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.6.tar.gz"
  sha256 "326513be00da3e4c9226da96c1a7e0b6a8b8ca017295ec529defda17fa2cebd5"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e93a718e7db9f90da7b127af56a70d15c12837bfd6ea464a7f086e00cb1941c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e93a718e7db9f90da7b127af56a70d15c12837bfd6ea464a7f086e00cb1941c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e93a718e7db9f90da7b127af56a70d15c12837bfd6ea464a7f086e00cb1941c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ab49e627696ef9bf2c4f304e43704facc48c85394f0170c5b94cf761d20acb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cf8ed8aff0f3b2e90ce8463fa2e7be9da80c6702e3a33f0440a872b03df63e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6969252e1d034d371f1bd4cb098fcbeff88c478cf934e92347400ca09f500d"
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
