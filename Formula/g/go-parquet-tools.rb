class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.5.tar.gz"
  sha256 "553f9ec105ec6a15b321fcb127f6a7ba2b357e162a074c391dd79d3da482e163"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f786ca3cdc5e2d2f27bddaba1594a8dadb2ade41564271d4338bd217713bb93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f786ca3cdc5e2d2f27bddaba1594a8dadb2ade41564271d4338bd217713bb93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f786ca3cdc5e2d2f27bddaba1594a8dadb2ade41564271d4338bd217713bb93"
    sha256 cellar: :any_skip_relocation, sonoma:        "40e860b0ad1850d7e691c1257b3640947e61b8cc739304161f1f487acb750756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50c08eddb4baeba841bf0e013d4397b729e53cfafff338c1e0b0968446d5b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dce2192b8411d96359911f7f2e4ee514221e78c5a9f2f02d3844ddd12ed9537"
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
