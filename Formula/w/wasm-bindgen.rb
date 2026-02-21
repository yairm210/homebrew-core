class WasmBindgen < Formula
  desc "Facilitating high-level interactions between Wasm modules and JavaScript"
  homepage "https://wasm-bindgen.github.io/wasm-bindgen/"
  url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.110.tar.gz"
  sha256 "772acc3dd2c8e87ffdb54880c689915b6b0c423cd6caa75bc843ce9a70994f26"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0183cb2d7418b222664fd0402ed0ca484de14d8bded8c12ae3d80edec5707f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "915eaf15e553e6be53fe15845f52e0521a8bca84edbf7765ecf74e37c2cda3ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb72ebd441bb890e51dfd669296fcf1078150c1cccfe905f95842d1202e70e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5555e407963833798db2651a138eaaf3101372fc52736180971fb93526533a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4fbb53e12298342f4f82a61dda3608a63341a654c08e9d0a99fc61124a06b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669b7ea7fd5a29bffac07c26789de97bf7df599b37df778bcc2c818f1df67367"
  end

  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wasm-bindgen --version")

    (testpath/"src/lib.rs").write <<~RUST
      use wasm_bindgen::prelude::*;

      #[wasm_bindgen]
      extern "C" {
          fn alert(s: &str);
      }

      #[wasm_bindgen]
      pub fn greet(name: &str) {
          alert(&format!("Hello, {name}!"));
      }
    RUST
    (testpath/"Cargo.toml").write <<~TOML
      [package]
      authors = ["The wasm-bindgen Developers"]
      edition = "2021"
      name = "hello_world"
      publish = false
      version = "0.0.0"

      [lib]
      crate-type = ["cdylib"]

      [dependencies]
      wasm-bindgen = "#{version}"
    TOML
    (testpath/"package.json").write <<~JSON
      {
        "name": "hello_world",
        "version": "0.0.0",
        "type": "module"
      }
    JSON
    (testpath/"index.js").write <<~JS
      globalThis.alert = console.log;
      import { greet } from './pkg/hello_world.js';

      greet('World');
    JS

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "wasm32-unknown-unknown"

    # Prevent Homebrew/CI AArch64 CPU features from bleeding into wasm32 builds
    ENV.delete "RUSTFLAGS"
    ENV.delete "CARGO_ENCODED_RUSTFLAGS"

    # Explicitly enable reference-types to resolve "failed to find intrinsics" error
    ENV["RUSTFLAGS"] = "-C target-feature=+reference-types"
    system "cargo", "build", "--target", "wasm32-unknown-unknown", "--manifest-path", "Cargo.toml"
    system bin/"wasm-bindgen", "target/wasm32-unknown-unknown/debug/hello_world.wasm",
                              "--out-dir", "pkg", "--reference-types"

    output = shell_output("node index.js")
    assert_match "Hello, World!", output.strip
  end
end
