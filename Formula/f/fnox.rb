class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "15ddcaa6ddb2843bfaa1058ce1a430a988c9b5bdbf6c44819d42ec455c9f2ff9"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c57ce59749ef45a8d5d01d4d2a0111c434813ca7c7988434cd0209f52176b3f"
    sha256 cellar: :any, arm64_tahoe:       "f8788b6cf7529cdd5fb9893b9eeba63045db5aca9be360a6437061078506057e"
    sha256 cellar: :any, arm64_sequoia:     "f8260eb955fda6ef7e54ede7900ac7ac4e94d2e6b6a5f7a48adfbd543bd1db41"
    sha256 cellar: :any, arm64_linux:       "536acfb3a50a23a2a2e264fd3030fa16f109e78fc11d48dc9febf7fa62d98f63"
    sha256 cellar: :any, x86_64_linux:      "9b810266bfa7f558d2ba50f1804dd6a7b7d43f5a4452caa1488a6c74ead239bb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "openssl@3"
  depends_on "usage"

  on_linux do
    depends_on "systemd" # libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnox --version")

    test_key = shell_output("age-keygen")
    test_key_line = test_key.lines.grep(/^# public key:/).first.sub(/^# public key: /, "").strip
    secret_key_line = test_key.lines.grep(/^AGE-SECRET-KEY-/).first.strip

    (testpath/"fnox.toml").write <<~TOML
      [providers]
      age = { type = "age", recipients = ["#{test_key_line}"] }
    TOML

    ENV["FNOX_AGE_KEY"] = secret_key_line
    system bin/"fnox", "set", "TEST_SECRET", "test-secret-value", "--provider", "age"
    assert_match "TEST_SECRET", shell_output("#{bin}/fnox list")
    assert_match "test-secret-value", shell_output("#{bin}/fnox get TEST_SECRET")
  end
end
