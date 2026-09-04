class DatadogStaticAnalyzer < Formula
  desc "Static analysis tool for code quality and security"
  homepage "https://docs.datadoghq.com/security/code_security/static_analysis/"
  url "https://github.com/DataDog/datadog-static-analyzer/archive/refs/tags/0.9.5.tar.gz"
  sha256 "9ada5dd2edd8308fc7bcab556864d1b4ffa332f50ac1bac80a26d2274b9b330c"
  license "Apache-2.0"
  head "https://github.com/DataDog/datadog-static-analyzer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c0f49929d0b61d18aaac3644e27c316cfe7a2b27cd3865535b9149ac7257eec"
    sha256 cellar: :any, arm64_sequoia: "99b0b0c8f1713486b19c6121cd5f6c97842cd7fb14335d910819499243aa1710"
    sha256 cellar: :any, arm64_sonoma:  "c9e89c5f9295578c888df1d0ea88f687e38bdc5c1972b7d7e0c9ed8580b05b7a"
    sha256 cellar: :any, arm64_linux:   "7d63283f432bf3f088eb9318a9d9405a61553503033f7774739c6912386cd673"
    sha256 cellar: :any, x86_64_linux:  "6b96e8d658c1288df3020a889ffc05d926aa788110c840988936ad4b26b809df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", "--bin", "datadog-static-analyzer",
                               "--bin", "datadog-static-analyzer-git-hook",
                               *std_cargo_args(path: "crates/bins")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datadog-static-analyzer --version")

    (testpath/"test.py").write "import os\n"
    (testpath/"static-analysis.datadog.yml").write <<~YAML
      rulesets:
        - python-best-practices
    YAML
    output = shell_output("#{bin}/datadog-static-analyzer -i #{testpath} -f sarif " \
                          "-o #{testpath}/output.sarif")
    assert_match "Static Analysis Summary", output
    assert_path_exists testpath/"output.sarif"
  end
end
