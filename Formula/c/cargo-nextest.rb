class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.126.tar.gz"
  sha256 "f6f1af7270e7a3f4e82dfd903f625dd4f1b278c601e7e6d470585e7e46e904cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5b4c691f85fdfca51d0d02aa2be1029f70c3ced83a437f852c0e98077ef9c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a47faf51869dd05cf7ede3cd1ea0842ac21140d693851788335431d14cbe464a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c518ccb7d8f8bcf47f5a70c928bbdf5ddc858614f46df5523c9e672d5b7ada6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd914e878be1fd872169155042a9db9d4d081f7be1eed97a14f45acd689cbfa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "899e073d355181407659085727f37fc43861be0ec2d0d405246b3426245e6694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5bfa9464ac29d36ee0cdbe098523193d874804b2551319784cecf16dfc7455e"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
