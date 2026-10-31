class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "13b6037d031d411135a1c991615d8305e4e2993ab0a8854e0e6d453280ae3949"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ffc9c30842ab8ff96fb7e0185870c64db2b759d73643e75ca4022c9ba6d3b85b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e81ca7ae6ec3f2ec817ed8f1c58af3bfb3f9a8fdbbdcfc32aa113a212da6dd0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6358ef5c0da41a7bd4b911130eb96ec64c8a2d541ae7c79bd37392db8bd54397"
    sha256 cellar: :any,                 arm64_linux:       "5f0b511c64af62f5053f1e4571a5a97a68b514f22840c32d16656b24fc881bcc"
    sha256 cellar: :any,                 x86_64_linux:      "fbf2cb175cec5f40ebec22fcb6312892dd6a3218beb83afa099555a3d91762b8"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites 2>&1")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath/"brewtest"
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read
  end
end
